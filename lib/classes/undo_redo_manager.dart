class UndoRedoManager<E> {
	List<E> _undoStack;
	List<E> _redoStack;
	E? _curData;
	bool _initialized = false;
	final int _maxSize;
	bool _hasSizeLimit = false;

	UndoRedoManager({int maxSize = 150}) : _maxSize = maxSize, _undoStack = [], _redoStack = [] {
		if (_maxSize > 0) {
			_hasSizeLimit = true;
		} // end if
	} // end UndoRedoManager

	int get _size {
		return _undoStack.length + _redoStack.length;
	}

	List<E> get undoStack {
		return List.castFrom(_undoStack);
	}

	List<E> get redoStack {
		return List.castFrom(_redoStack);
	}

	void addData(E data) {
		//print("1: $_undoStack - - $_curData != $data - - $_redoStack");
		// if (!hasUndo() || peekUndo() != data) {
		// 	_undoStack.add(data);
		// }
		// _redoStack.clear();
		if (!_initialized) {
			_curData = data;
			_initialized = true;
		} else {
			if (!identical(_curData, data)) {
				//print('boink');
				_undoStack.add(_curData as E);
				_curData = data;
				_redoStack.clear();
			} else {
				//print ("nope");
			}
		}
		//print("2: $_undoStack - - $_curData != $data - - $_redoStack ${data.runtimeType}");
		// if (hasUndo() && data == peekUndo()) {
		// 	return;
		// }
		// //print("$_undoStack - - $_lastData - - $_redoStack");
		// _undoStack.add(data);
		// _redoStack.clear();
		// while (_hasSizeLimit && _size > _maxSize) {
		// 	_undoStack.removeAt(0);
		// } // end while
		// //print("$_undoStack - - $_lastData - - $_redoStack");
	} // end addState

	bool hasUndo() {
		return _undoStack.isNotEmpty;
	}

	E undo() {
		//print("$_undoStack - - $_curData - - $_redoStack");
		if (hasUndo()) {
			E data = _undoStack.removeLast();
			_redoStack.add(_curData as E);
			_curData = data;
			//print("$_undoStack - - $_curData - - $_redoStack");
			return data;
		}
		throw Exception("Undo list empty");
	}

	E peekUndo() {
		if (hasUndo()) {
			return _undoStack.last;
		}
		throw Exception("Undo list empty");
	}

	bool hasRedo() {
		return _redoStack.isNotEmpty;
	}

	E redo() {
		//print("$_undoStack - - $_curData - - $_redoStack");
		if (hasRedo()) {
			E data = _redoStack.removeLast();
			_undoStack.add(_curData as E);
			_curData = data;
			//print("$_undoStack - - $_curData - - $_redoStack");
			return data;
		}
		throw Exception("Redo list empty");
	}

	E peekRedo() {
		if (hasRedo()) {
			return _redoStack.last;
		}
		throw Exception("Redo list empty");
	}

} // end UndoRedoManager


// class SaveStateTimeline<E> {
// 	/// the most recent state
// 	SaveState<E> _head;
// 	/// the original state
// 	SaveState<E> _tail;
// 	SaveState<E> _index;
// 	int _numOfStates = 0;
// 	int _maxNumOfStates = 150;

// 	SaveStateTimeline(E currentState, {int maxStates = 150})
// 	: _head = SaveState(data: currentState),
// 		_tail = SaveState(data: currentState),
// 		_index = SaveState(data: currentState)
// 	{
// 		_tail = _head;
// 		_index = _head;
// 		_numOfStates = 1;

// 		// if user entered a value for max states, use it
// 		_maxNumOfStates = maxStates;
// 	} // end SaveStateTimeline

// 	void saveState(E currentState) {
// 		SaveState<E> tempState = SaveState(data: currentState, prev: _index);
// 		_index.next = tempState;
// 		_head = _index = tempState;
// 		_numOfStates = index + 1;
// 		if (_maxNumOfStates > 0 && _numOfStates > _maxNumOfStates) {
// 			deleteOldest();
// 		} // end if
// 	} // end saveState

// 	void deleteOldest() {
// 		if (_tail.next != null) {
// 			_tail = _tail.next as SaveState<E>;
// 			_numOfStates --;
// 		} // end if
// 	}

// 	E getPrevData() {
// 		if (_index.prev != null) {
// 			_index = _index.prev as SaveState<E>;
// 		} // end if
// 		E data = _index.data;
// 		return data;
// 	} // end getLastData

// 	E peekPrevData() {
// 		E data = _index.prev!.data;
// 		return data;
// 	} // end getLastData

// 	E getNextData() {
// 		if (_index.next != null) {
// 			_index = _index.next as SaveState<E>;
// 		} // end if
// 		E data = _index.data;
// 		return data;
// 	} // end getNextData

// 	E peekNextData() {
// 		E	data = _index.next!.data;
// 		return data;
// 	} // end getNextData

// 	E getCurData() {
// 		return _index.data;
// 	} // end getNextData

// 	int get numOfSaves {
// 		return _numOfStates;
// 	}

// 	int get index {
// 		SaveState cursor = _tail;
// 		int i = 0;
// 		while (cursor != _index) {
// 			cursor = cursor.next!;
// 			i ++;
// 		}
// 		return i;
// 	}

// 	bool hasPrev() {
// 		return _index.prev != null;
// 	}

// 	bool isLead() {
// 		return _index == _head;
// 	}

// } // end SaveStateTimeline

// class SaveState<E> {
// 	SaveState<E>? _previousState;
// 	SaveState<E>? _nextState;
// 	E _data;

// 	SaveState({required E data, SaveState<E>? prev, SaveState<E>? next}): _data = data{
// 		_data = data;
// 		_previousState = prev;
// 		_nextState = next;
// 	} // end SaveState

// 	E get data {
// 		return _data;
// 	}

// 	set next(SaveState<E>? st) {
// 		_nextState = st;
// 	}

// 	SaveState<E>? get next {
// 		return _nextState;
// 	}

// 	set prev(SaveState<E>? st) {
// 		_previousState = st;
// 	}

// 	SaveState<E>? get prev {
// 		return _previousState;
// 	}

// } // end SaveState


// /* =========== HELPERS =========== */
