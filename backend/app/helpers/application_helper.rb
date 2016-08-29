module ApplicationHelper

  # connects the user to the AWS in order to query for assets
  def connect_to_bucket
    begin
      aws = Amazon.find(1)
      key_id = aws[:key_id]
      secret_key = aws[:secret_key]
      bucket_name = aws[:bucket_name]
      Aws.config.update({
        region: 'us-east-1',
        credentials: Aws::Credentials.new(key_id, secret_key)
      })

      @S3_BUCKET = Aws::S3::Resource.new.bucket(bucket_name)
    rescue Aws::S3::Errors::ServiceError
      response_data('Error connecting to AWS S3', nil, 400)
    end
  end

  def upload_file(key, path)
    Aws::S3::Resource.new.bucket(@S3_BUCKET.name).object(key).upload_file(path, acl: 'private')
  end

  def create_url(key)
    @url = @S3_BUCKET.object(key).presigned_url(:get, expires_in: 3600)
  end

  def get_url_list
    begin
      @url_list = []
      @S3_BUCKET.objects.each do |x|
        create_url(x.key)  # see application_helper
        @url_list.push(@url)
      end
    rescue Aws::S3::Errors::ServiceError
      return response_data('Failed to get assets', nil, 400)
    end
  end

  # this function checks the user's roles against the roles allowed by a specific
  # model (such as pages) in order to verify authorization to access methods in
  # the controller
  def authorize_role
    type = controller_name().chop
    upper_type = type.slice(0,1).capitalize + type.slice(1..-1)
    user_id = JsonWebToken.decode(request.headers['Authorization'].split(' ').last)[0]['user']
    if User.exists?(user_id) 
      if eval(upper_type).exists?(params[:id])
        if UserRole.exists?(:user_id => user_id)
          user = User.find(user_id).roles
          check_type = eval(upper_type).find(params[:id]).roles
          # this evaluation will fail if no role exists for the object you are trying to access
          if !check_type.blank?
            if user[0][:id] == check_type[0][:id]
              @authorized = true
            else
              @authorized = false
              @response = 'You do not have permission to edit that ' + type
            end
          else
            @authorized = false
            @response = 'That ' + type + ' does not have a role associated to it, you are not authorized to perform this action.'
          end
        else
          @authorized = false
          @response = 'You do not have a role.'
        end
      else
        @authorized = false
        @response = upper_type + ' does not exist.'
      end
    else
      @authorized = false
      @response = 'User does not exist.'
    end
  end

  # checks the users role against a portlet
  # all queries against portlets use portlet_id rather than id
  # therefore this function was created for that specific use case
  def authorize_portlet_role
    type = controller_name().chop
    upper_type = type.slice(0,1).capitalize + type.slice(1..-1)
    user_id = JsonWebToken.decode(request.headers['Authorization'].split(' ').last)[0]['user']
    portlet = eval(upper_type).where(is_deleted: false, portlet_id: params[:portlet_id])[0]
    if User.exists?(user_id)
      if !portlet.blank?
        if UserRole.exists?(:user_id => user_id)
          user = User.find(user_id).roles
          check_type = eval(upper_type).find(portlet[:id]).roles
          # this evaluation will fail if no role exists for the portlet
          if !check_type.blank?
            if user[0][:id] == check_type[0][:id]
              @authorized = true
            else
              @authorized = false
              @response = 'You do not have permission to edit that ' + type
            end
          else
            @authorized = false
            @response = 'That ' + type + ' does not have a role associated to it, you are not authorized to perform this action.'
          end
        else
          @authorized = false
          @response = 'You do not have a role.'
        end
      else
        @authorized = false
        @response = upper_type + ' does not exist.'
      end
    else
      @authorized = false
      @response = 'User does not exist.'
    end
  end

  # checks the users role against a portlet
  # this is a similar function to above, but instead is used inside a loop
  # rather than with request parameters
  def authorize_specific_portlet_role(portlet_id)
    type = controller_name().chop
    upper_type = type.slice(0,1).capitalize + type.slice(1..-1)
    user_id = JsonWebToken.decode(request.headers['Authorization'].split(' ').last)[0]['user']
    portlet = eval(upper_type).where(is_deleted: false, portlet_id: portlet_id)[0]
    if User.exists?(user_id)
      if !portlet.blank?
        if UserRole.exists?(:user_id => user_id)
          user = User.find(user_id).roles
          check_type = eval(upper_type).find(portlet[:id]).roles
          # this evaluation will fail if no role exists for the portlet
          if !check_type.blank?
            if user[0][:id] == check_type[0][:id]
              @authorized = true
            else
              @authorized = false
              @response = 'You do not have permission to edit that ' + type
            end
          else
            @authorized = false
            @response = 'That ' + type + ' does not have a role associated to it, you are not authorized to perform this action.'
          end
        else
          @authorized = false
          @response = 'You do not have a role.'
        end
      else
        @authorized = false
        @response = upper_type + ' does not exist.'
      end
    else
      @authorized = false
      @response = 'User does not exist.'
    end
  end

  # this function checks the user against the roles table
  # it checks to see if they have permission to create a new entry
  # in any table
  def check_permissions
    type = controller_name().chop
    create = ':can_create_' + type + 's'
    user_id = JsonWebToken.decode(request.headers['Authorization'].split(' ').last)[0]['user']
    if User.exists?(user_id)
      if UserRole.exists?(:user_id => user_id)
        @user = User.find(user_id).roles
        if (@user[0][eval(create)])
          @authorized = true
        else
          @authorized = false
          @response = 'You do not have permission to edit that ' + type
        end
      else
        @authorized = false
        @response = 'You do not have permission to edit that ' + type
      end
    else
      @authorized = false
      @response = 'User does not exist.'
    end
  end
end
