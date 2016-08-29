import { TEST_ACTION } from '../constants/ActionTypes.js';

const initialState = {
	thisWorks: false
}

export default function AppState(state = initialState, action) {
	
	switch (action.type) {

	case TEST_ACTION: 
		const newState = {
			thisWorks: true
		}
	return newState;

	default: 
		return state;
	}
}
