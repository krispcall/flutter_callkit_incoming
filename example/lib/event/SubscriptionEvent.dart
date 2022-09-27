import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";

class SubscriptionWorkspaceOrChannelChanged {
  String? event;
  WorkspaceChannel? workspaceChannel;
  SubscriptionWorkspaceOrChannelChanged({this.event, this.workspaceChannel});
}

class SubscriptionCallLogEvent {
  String? event;
  RecentConversationNodes? recentConversationNodes;
  SubscriptionCallLogEvent({this.event, this.recentConversationNodes});
}

class SubscriptionMemberOnlineEvent {
  String? event;
  MemberStatus? memberStatus;
  SubscriptionMemberOnlineEvent({this.event, this.memberStatus});
}

class SubscriptionMemberChatDetail {
  String? event;
  RecentConversationMemberNodes? recentConversationMemberNodes;
  SubscriptionMemberChatDetail(
      {this.event, this.recentConversationMemberNodes});
}

class UserOnlineOfflineEvent {
  bool? online;

  UserOnlineOfflineEvent({this.online});
}

class SubscriptionConversationSeenEvent {
  bool? isSeen;
  SubscriptionConversationSeenEvent({this.isSeen});
}
