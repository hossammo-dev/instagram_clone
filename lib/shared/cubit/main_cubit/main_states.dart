abstract class MainStates {}

class MainInitState extends MainStates {}

class MainChangeIndexState extends MainStates {}

class MainChangeGridState extends MainStates {}

class MainLoadingState extends MainStates {}

//users

  //get user data
  class MainGetuserDataSuccessState extends MainStates {}
  class MainGetuserDataErrorState extends MainStates {}

  //get all users
  class MainGetAllUsersSuccessState extends MainStates {}
  class MainGetAllUsersErrorState extends MainStates {}

  //follow user
  class MainFollowUserSuccessState extends MainStates{}
  class MainFollowUserErrorState extends MainStates{}

  //unfollow user
  class MainUnFollowUserSuccessState extends MainStates{}
  class MainUnFollowUserErrorState extends MainStates{}

  //edit profile states
  class MainEditProfileSuccessState extends MainStates{}
  class MainEditProfileErrorState extends MainStates{}

//post

  //get posts
  class MainGetPostsSuccessState extends MainStates {}
  class MainGetPostsErrorState extends MainStates {}

  //create post
  class MainCreatePostSuccessState extends MainStates {}
  class MainCreatePostErrorState extends MainStates {}

  //post like

    //like post
    class MainLikePostSuccessState extends MainStates {}
    class MainLikePostErrorState extends MainStates {}

    //remove like
    class MainRemoveLikeSuccessState extends MainStates {}
    class MainRemoveLikeErrorState extends MainStates {}


  //comment post
  class MainCommentPostSuccessState extends MainStates {}
  class MainCommentPostErrorState extends MainStates {}

  //bookmark post
  class MainBookmarkPostSuccessState extends MainStates {}
  class MainBookmarkPostErrorState extends MainStates {}


//message

  //send message
  class MainSendMessageSuccessState extends MainStates{}
  class MainSendMessageErrorState extends MainStates{}

  //get messages
  class MainGetMessagesSuccessState extends MainStates{}
  class MainGetMessagesErrorState extends MainStates{}