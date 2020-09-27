

class Keys with GlobalKeys, ContentKeys, QuestionKeys, ProfileKeys, CommonRelationsKeys, UploadKeys, MemberKeys, ChannelKeys, UrlKeys, ResponseKeys, NotificationSettingsKeys, DeviceKeys {

  static final Keys _instance = Keys._internal();

  factory Keys () {
    return _instance;
  }

  Keys._internal();

}


class GlobalKeys {
  final String deleted = "deleted";
  final String id = "id";
  final String dateModified = "date_modified";
  final String dateAdded = "date_added";
  final String name = "name";
  final String imageUrl = "image_url";
  final String colorIndex = "color_index";
  final String enabled = "enabled";
  final String valid = "valid";
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
  final String reason = "reason";

  final String viewCount = "view_count";
  final String questionViewTime = "question_view_time";
  final String isUpdated = "is_updated";
  final String isNew = "is_new";

  final String vote = "vote";
  final String votesCount = "votes_count";
  final String myVote = "my_vote";

  final String commentsCount = "comments_count";
  final String commentsUpdates = "comments_updates";

  final String voted = "voted";
  final String edited = "edited";

  final String newComment = "new_comment";
  final String editedComment = "edited_comment";

  final String copyOfVersionId = "copy_of_version_id";
  final String copyOfVersion = "copy_of_version";

  final String overriddenEventPreferencesId = "overridden_event_preferences_id";
  final String overriddenEventPreferences = "overridden_event_preferences";
}

class QuestionKeys {

  final String correctAnswerId = "correct_answer_id";
  final String correctAnswer = "correct_answer";

  final String flaggedDuplicate = "flagged_duplicate";
  final String flaggedDuplicateByMe = "flagged_duplicate_by_me";
  final String duplicateFlagsCount = "duplicate_flags_count";
  final String duplicateOfQuestionIds = "duplicate_of_question_ids";

  final String answerCount = "answer_count";
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
  final String members = "members";
  final String question = "question";
  final String questionId = "question_id";
  final String tagIds = "tag_ids";
  final String reporters = "reporters";
}

class UploadKeys {

  final String uploadUrl = "upload_url";
  final String localFileName = "local_file_name";
  final String isImage = "is_image";
  final String width = "width";
  final String height = "height";
  final String mode = "mode";
  final String miniUrl = "mini_url";
  final String file = "file";
  final String includeMini = "mini";
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
  final String isCurrentUserAdmin = "is_current_user_admin";

}

class NotificationSettingsKeys {
  final String autoFollowQuestions = "auto_follow_questions";
  final String autoFollowAnswers = "auto_follow_answers";
  final String autoFollowComments = "auto_follow_comments";
  final String autoFollowQuestionsOnComment = "auto_follow_questions_on_comment";
  final String autoFollowQuestionsOnAnswer = "auto_follow_questions_on_answer";
  final String autoFollowQuestionsOnAnswerComment = "auto_follow_questions_on_answer_comment";
  final String autoFollowAnswersOnComment = "auto_follow_answers_on_comment";
  final String sendNewMembersNotification = "send_new_members_notification";
  final String sendNotificationMyMemberInfoUpdated = "send_notification_my_member_info_updated";
  final String sendNewDataNotification = "send_new_data_notification";
  final String questionEventPreferences = "question_event_preferences";
  final String answerEventPreferences = "answer_event_preferences";
  final String commentEventPreferences = "comment_event_preferences";
  final String questionTaggingPreferences = "question_tagging_preferences";
  final String answerTaggingPreferences = "answer_tagging_preferences";
  final String questionCommentTaggingPreferences = "question_comment_tagging_preferences";
  final String answerCommentTaggingPreferences = "answer_comment_tagging_preferences";
  final String followUpperQuestion = "follow_upper_question";
  final String followUpperAnswer = "follow_upper_answer";
  final String followSelf = "follow_self";
}


class UrlKeys {

  final String search = "search";
  final String mode = "mode";
  final String filterMode = "filter_mode";
  final String offset = "offset";
  final String roles = "roles";
  final String users = "users";
  final String limit = "limit";
  final String orderType = "order_type";
  final String showDeletedAnswers = "show_deleted_answers";

}

class DeviceKeys {

  final String registrationToken = "registration_token";

}

class ResponseKeys {

  final String results = "results";
  final String object = "object";

}


