class PaginationResponse<T> {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<T> data;

  const PaginationResponse({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final rawList = (json['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    return PaginationResponse(
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? rawList.length,
      total: (json['total'] as num?)?.toInt() ?? rawList.length,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      data: rawList.map(fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJson) {
    return {
      'page': page,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
      'data': data.map(toJson).toList(),
    };
  }
}
