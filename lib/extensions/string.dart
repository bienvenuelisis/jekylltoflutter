extension StringToDate on String {
  String get capitalize =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";

  String get capitalizeWords =>
      split(" ").map((str) => str.capitalize).join(" ");
}
