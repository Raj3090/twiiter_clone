class UserModel{

  final String email;
  final String name;
  final String bannerPic;
  final String profilePic;
  final String uid;
  final String bio;
  final bool isTwitterBlue;
  final List<String> followers;
  final List<String> following;

  UserModel(this.email, this.name, this.bannerPic, this.profilePic, this.uid, this.bio, this.isTwitterBlue, this.followers, this.following);



}