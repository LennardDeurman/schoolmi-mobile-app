import 'package:schoolmi/network/keys.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/abstract/base.dart';
import 'package:schoolmi/network/models/extensions/object_with_attachments.dart';
import 'package:schoolmi/network/models/extensions/object_with_votes.dart';
import 'package:schoolmi/network/models/extensions/object_with_comments.dart';
import 'package:schoolmi/network/models/extensions/object_with_followers.dart';
import 'package:schoolmi/network/models/extensions/object_with_flags.dart';
import 'package:schoolmi/network/models/extensions/object_with_views.dart';
import 'package:schoolmi/network/models/linkages/channel_linked_object.dart';
import 'package:schoolmi/network/models/linkages/profile_linked_object.dart';
import 'package:schoolmi/network/models/linkages/identity_linked_object.dart';
import 'package:schoolmi/network/models/identity.dart';

class ContentObject extends BaseObject with ChannelLinkedObject,
    ProfileLinkedObject, ObjectWithAttachments,
    ObjectWithVotes, ObjectWithComments,
    ObjectWithFollowers, ObjectWithFlags, ObjectWithViews, IdentityLinkedObject {

  bool anonymous;
  String body;
  String contentUuid;

  ContentObject (Map<String, dynamic> dictionary) : super(dictionary);

  @override
  void parse(Map<String, dynamic> dictionary) {
    parseContentInfo(dictionary);
    parseChannelLink(dictionary);
    parseProfileLink(dictionary);
    parseAttachments(dictionary);
    parseFollowersInfo(dictionary);
    parseFlagsInfo(dictionary);
    parseVotesInfo(dictionary);
    parseCommentsInfo(dictionary);
    parseViewsInfo(dictionary);
    super.parse(dictionary);
  }

  void parseContentInfo(Map<String, dynamic> dictionary) {

    anonymous = ParsableObject.parseBool(dictionary[Keys().anonymous]);
    body = dictionary[Keys().body];
    contentUuid = dictionary[Keys().contentUuid];

  }

  Map<String, dynamic> contentDictionary() {
    return {
      Keys().anonymous: anonymous,
      Keys().body: body,
      Keys().contentUuid: contentUuid
    };
  }

  @override
  Map<String, dynamic> toDictionary() {
    Map dictionary = super.toDictionary();
    dictionary.addAll(contentDictionary());
    dictionary.addAll(votesInfo.votesInfoDictionary());
    dictionary.addAll(flagsInfoDictionary());
    dictionary.addAll(commentsInfoDictionary());
    dictionary.addAll(followersDictionary());
    dictionary.addAll(viewsDictionary());

    dictionary.addAll(profileLinkDictionary());
    dictionary.addAll(channelLinkDictionary());
    dictionary.addAll(attachmentsDictionary());
    return dictionary;
  }

  Identity get identity {
    return Identity(member: member, profile: profile);
  }

}