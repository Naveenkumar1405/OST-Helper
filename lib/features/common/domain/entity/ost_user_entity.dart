class OSTUserEntity {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  final List<String> products;

  OSTUserEntity({
    required this.uid,
    required this.name,
    required this.profileUrl,
    required this.email,
    required this.products,
  });
}
