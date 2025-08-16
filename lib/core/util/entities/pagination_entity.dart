class PaginationEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginationEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });
}
