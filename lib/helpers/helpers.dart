String formatDate(DateTime date) {
	String formattedDate = 
		"${date.year.toString().padLeft(4, '0')}-"
		"${date.month.toString().padLeft(2, '0')}-"
		"${date.day.toString().padLeft(2, '0')} "
		"${date.hour.toString().padLeft(2, '0')}:"
		"${date.minute.toString().padLeft(2, '0')}";
		return formattedDate;
}