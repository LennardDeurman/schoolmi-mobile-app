

class Keys with GlobalKeys, ContentKeys, QuestionKeys, ProfileKeys, CommonRelationsKeys, UploadKeys, MemberKeys, ChannelKeys {

  static final Keys _instance = Keys()._internal();

  factory Keys () {
    return _instance;
  }

  Keys()._internal();

}


class GlobalKeys {
  final String deleted = "deleted";
  final String id = "id";
  final String dateModified = "date_modified";
  final String dateAdded = "date_added";
  final String name = "name";
  final String imageUrl = "image_url";
  final String colorIndex = "color_index";
}

class ContentKeys {

  final String contentUuid = "content_uuid";
  final String parentContentUuid = "parent_content_uuid";
  final String anonymous = "anonymous";
  final String body = "body";

  final String followedByMe = "followed_by_me";
  final String followersCount = "followers_count";

  final String flagged = "flagged";
  final String flagsCount = "flags_count";
  final String flaggedByMe = "flagged_by_me";

  final String viewCount = "view_count";
  final String questionViewTime = "question_view_time";
  final String isUpdated = "is_updated";
  final String isNew = "is_new";

  final String vote = "vote";
  final String votesCount = "votes_count";
  final String myVote = "my_vote";

  final String commentsCount = "comments_count";
  final String commentsUpdates = "comments_updates";
}

class QuestionKeys {

  final String correctAnswerId = "correct_answer_id";
  final String correctAnswer = "correct_answer";

}

class ProfileKeys {

  final String activeChannel = "active_channel";
  final String activeChannelId = "active_channel_id";
  final String firebaseUid = "firebase_uid";
  final String email = "email";
  final String firstName = "firstname";
  final String lastName = "lastname";
  final String username = "username";
  final String about = "about";
  final String score = "score";

}

class CommonRelationsKeys {

  final String tag = "tag";
  final String tagId = "tag_id";
  final String role = "role";
  final String roleId = "role_id";
  final String upload = "upload";
  final String uploadId = "upload_id";
  final String attachments = "attachments";
  final String tags = "tags";
  final String profile = "profile";
  final String channel = "channel";
  final String channelId = "channel_id";
  final String member = "member";
  final String question = "question";
  final String questionId = "question_id";

}

class UploadKeys {

  final String uploadUrl = "upload_url";
  final String localFileName = "local_file_name";
  final String isImage = "is_image";
  final String width = "width";
  final String height = "height";
  final String mode = "mode";
  final String miniUrl = "mini_url";
}

class MemberKeys {


  final String blocked = "blocked";
  final String isAdmin = "is_admin";

}

class ChannelKeys {

  final String description = "description";
  final String membersCount = "members_count";
  final String updatesCount = "updates_count";
  final String isActiveChannel = "is_active";
  final String canAddTags = "can_add_tags";
  final String canPublicJoin = "can_public_join";
  final String joinCode = "join_code";
  final String membersCanInvite = "members_can_invite";

}






