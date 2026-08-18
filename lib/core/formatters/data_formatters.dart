String formatarData(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes/${data.year}';
}

String formatarDiasRestantes(DateTime dataEvento, DateTime hoje) {
  final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day);
  final inicioEvento = DateTime(
    dataEvento.year,
    dataEvento.month,
    dataEvento.day,
  );
  final dias = inicioEvento.difference(inicioHoje).inDays;

  if (dias == 0) return 'Hoje';
  if (dias == 1) return 'Amanhã';
  if (dias > 1) return 'Em $dias dias';
  if (dias == -1) return 'Ontem';
  return 'Há ${dias.abs()} dias';
}
