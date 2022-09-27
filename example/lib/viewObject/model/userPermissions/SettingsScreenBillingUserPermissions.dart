import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenBillingUserPermissions
    extends Object<SettingsScreenBillingUserPermissions> {
  final bool? overviewChangePlan;
  final bool? overviewPurchaseCredit;
  final bool? overviewManageCardAdd;
  final bool? overviewManageCardDelete;
  final bool? overviewHideKrispcallBranding;
  final bool? overviewNotificationAutoRecharge;
  final bool? overviewCancelSubscription;
  final bool? billingInfoSave;
  final bool? billingReceiptsViewList;
  final bool? billingReceiptsViewInvoice;
  final bool? billingReceiptsDownloadInvoice;

  SettingsScreenBillingUserPermissions(
      {this.overviewChangePlan,
      this.overviewPurchaseCredit,
      this.overviewManageCardAdd,
      this.overviewManageCardDelete,
      this.overviewHideKrispcallBranding,
      this.overviewNotificationAutoRecharge,
      this.overviewCancelSubscription,
      this.billingInfoSave,
      this.billingReceiptsViewList,
      this.billingReceiptsViewInvoice,
      this.billingReceiptsDownloadInvoice});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenBillingUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenBillingUserPermissions(
        overviewChangePlan: dynamicData["overview_change_plan"] == null
            ? null
            : dynamicData["overview_change_plan"] as bool,
        overviewPurchaseCredit: dynamicData["overview_purchase_credit"] == null
            ? null
            : dynamicData["overview_purchase_credit"] as bool,
        overviewManageCardAdd: dynamicData["overview_manage_card_add"] == null
            ? null
            : dynamicData["overview_manage_card_add"] as bool,
        overviewManageCardDelete:
            dynamicData["overview_manage_card_delete"] == null
                ? null
                : dynamicData["overview_manage_card_delete"] as bool,
        overviewHideKrispcallBranding:
            dynamicData["overview_hide_krispcall_branding"] == null
                ? null
                : dynamicData["overview_hide_krispcall_branding"] as bool,
        overviewNotificationAutoRecharge:
            dynamicData["overview_notification_auto_recharge"] == null
                ? null
                : dynamicData["overview_notification_auto_recharge"] as bool,
        overviewCancelSubscription:
            dynamicData["ovierview_cancel_subscription"] == null
                ? null
                : dynamicData["ovierview_cancel_subscription"] as bool,
        billingInfoSave: dynamicData["billing_info_save"] == null
            ? null
            : dynamicData["billing_info_save"] as bool,
        billingReceiptsViewList:
            dynamicData["billing_receipts_view_list"] == null
                ? null
                : dynamicData["billing_receipts_view_list"] as bool,
        billingReceiptsViewInvoice:
            dynamicData["billing_receipts_view_invoice"] == null
                ? null
                : dynamicData["billing_receipts_view_invoice"] as bool,
        billingReceiptsDownloadInvoice:
            dynamicData["billing_receipts_download_invoice"] == null
                ? null
                : dynamicData["billing_receipts_download_invoice"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenBillingUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["overview_change_plan"] = object.overviewChangePlan;
      data["overview_purchase_credit"] = object.overviewPurchaseCredit;
      data["overview_manage_card_add"] = object.overviewManageCardAdd;
      data["overview_manage_card_delete"] = object.overviewManageCardDelete;
      data["overview_hide_krispcall_branding"] =
          object.overviewHideKrispcallBranding;
      data["overview_notification_auto_recharge"] =
          object.overviewNotificationAutoRecharge;
      data["ovierview_cancel_subscription"] = object.overviewCancelSubscription;
      data["billing_info_save"] = object.billingInfoSave;
      data["billing_receipts_view_list"] = object.billingReceiptsViewList;
      data["billing_receipts_view_invoice"] = object.billingReceiptsViewInvoice;
      data["billing_receipts_download_invoice"] =
          object.billingReceiptsDownloadInvoice;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenBillingUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenBillingUserPermissions> listMessages =
        <SettingsScreenBillingUserPermissions>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as SettingsScreenBillingUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
