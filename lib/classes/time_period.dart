class TimePeriod {
	DateTime startTime;
	late DateTime stopTime;
	bool _hasStopped = false;
	int hourlyPay = 0;
	String title = "";
	String location = "";
	String description = "";
	String status = "";
	Stopwatch e = Stopwatch()..start();

	TimePeriod({
		required this.startTime,
		DateTime? stopTime,
		this.hourlyPay = 0,
		this.title = "",
		this.location = "",
		this.description = "",
	}) {
		if (stopTime != null && startTime.compareTo(stopTime) >= 0) {
			this.stopTime = stopTime;
			_hasStopped = true;
		} // end if
	} // end TimePeriod

	Duration get time {
		if (_hasStopped) {
			return stopTime.difference(startTime);
		} else {
			return DateTime.now().difference(startTime);
		} // end if else
	} // end get time

	void stop() {
		stopTime = DateTime.now();
		_hasStopped = true;
		e.stop();
	} // end stop

} // end TimePeriod