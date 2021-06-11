String toDBString(DateTime fecha) {
  if (fecha == null) return '';
  return fecha.year.toString() +
      fecha.month.toString().padLeft(2, '0') +
      fecha.day.toString().padLeft(2, '0');
}

DateTime datetimeFromDBString(String fechaString) {
  if (fechaString == null || fechaString.length != 8) return null;

  final year = int.parse(fechaString.substring(0, 4));
  final month = int.parse(fechaString.substring(4, 6));
  final day = int.parse(fechaString.substring(6));
  return DateTime(year, month, day);
}
