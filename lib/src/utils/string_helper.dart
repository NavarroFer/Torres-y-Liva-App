String toDBString(DateTime fecha) {
  if (fecha == null) return '';
  return fecha.year.toString() +
      fecha.month.toString().padLeft(2, '0') +
      fecha.day.toString().padLeft(2, '0') +
      fecha.hour.toString().padLeft(2, '0') +
      fecha.minute.toString().padLeft(2, '0') +
      fecha.second.toString().padLeft(2, '0');
}

DateTime datetimeFromDBString(String fechaString) {
  if (fechaString == null || fechaString.length != 14) return null;

  final year = int.parse(fechaString.substring(0, 4));
  final month = int.parse(fechaString.substring(4, 6));
  final day = int.parse(fechaString.substring(6, 8));
  final hour = int.parse(fechaString.substring(8, 10));
  final minute = int.parse(fechaString.substring(10, 12));
  final second = int.parse(fechaString.substring(12, 14));
  return DateTime(year, month, day, hour, minute, second);
}
