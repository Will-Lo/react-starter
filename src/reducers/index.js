import { combineReducers } from 'redux';
import TestStore from './TestReducer';

export default combineReducers(
  Object.assign({}, {
  	TestStore
  })
);