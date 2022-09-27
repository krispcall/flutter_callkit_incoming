import "package:contacts_service/contacts_service.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/src/size_extension.dart";
import "package:functional_widget_annotation/functional_widget_annotation.dart";
import "package:intl/intl.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  ///if you want to get all the details of phone then use _contact

  List<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  Future<void> refreshContacts() async {
    // Load without thumbnails initially.
    final contacts = await ContactsService.getContacts(
        withThumbnails: false, iOSLocalizedLabels: iOSLocalizedLabels);
    setState(() {
      _contacts = contacts;
    });

    // Lazy load thumbnails after rendering initial contacts.
    for (final contact in contacts) {
      ContactsService.getAvatar(contact).then((avatar) {
        if (avatar == null) return; // Don"t redraw if no change.
        setState(() => contact.avatar = avatar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight.h,
        title: const Text(
          Config.checkOverFlow ? Const.OVERFLOW : "Contacts",
        ),
      ),
      body: SafeArea(
        child: _contacts != null
            ? ListView.builder(
                itemCount: _contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final Contact? contact = _contacts?.elementAt(index);
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => contactDetailsPage(
                                contact!,
                                contactOnDeviceHasBeenUpdated,
                              )));
                    },
                    leading:
                        (contact!.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!))
                            : CircleAvatar(
                                child: Text(Config.checkOverFlow
                                    ? Const.OVERFLOW
                                    : contact.initials())),
                    title: Text(Config.checkOverFlow
                        ? Const.OVERFLOW
                        : contact.displayName ?? ""),
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  void contactOnDeviceHasBeenUpdated(Contact contact) {
    setState(() {
      final id =
          _contacts!.indexWhere((c) => c.identifier == contact.identifier);
      _contacts![id] = contact;
    });
  }
}

@swidget
Widget contactDetailsPage(
    Contact contact, Function(Contact) onContactDeviceSave) {
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: kToolbarHeight.h,
      title: Text(
          Config.checkOverFlow ? Const.OVERFLOW : contact.displayName ?? ""),
    ),
    body: SafeArea(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text(Config.checkOverFlow ? Const.OVERFLOW : "Name"),
            trailing: Text(Config.checkOverFlow
                ? Const.OVERFLOW
                : contact.givenName ?? ""),
          ),
          ListTile(
            title: const Text(
                Config.checkOverFlow ? Const.OVERFLOW : "Middle name"),
            trailing: Text(Config.checkOverFlow
                ? Const.OVERFLOW
                : contact.middleName ?? ""),
          ),
          ListTile(
            title: const Text(
                Config.checkOverFlow ? Const.OVERFLOW : "Family name"),
            trailing: Text(Config.checkOverFlow
                ? Const.OVERFLOW
                : contact.familyName ?? ""),
          ),
          ListTile(
            title: const Text(Config.checkOverFlow ? Const.OVERFLOW : "Prefix"),
            trailing: Text(
                Config.checkOverFlow ? Const.OVERFLOW : contact.prefix ?? ""),
          ),
          ListTile(
            title: const Text(Config.checkOverFlow ? Const.OVERFLOW : "Suffix"),
            trailing: Text(
                Config.checkOverFlow ? Const.OVERFLOW : contact.suffix ?? ""),
          ),
          ListTile(
            title:
                const Text(Config.checkOverFlow ? Const.OVERFLOW : "Birthday"),
            trailing: Text(Config.checkOverFlow
                ? Const.OVERFLOW
                : contact.birthday != null
                    ? DateFormat("dd-MM-yyyy").format(contact.birthday!)
                    : ""),
          ),
          ListTile(
            title:
                const Text(Config.checkOverFlow ? Const.OVERFLOW : "Company"),
            trailing: Text(
                Config.checkOverFlow ? Const.OVERFLOW : contact.company ?? ""),
          ),
          ListTile(
            title: const Text(Config.checkOverFlow ? Const.OVERFLOW : "Job"),
            trailing: Text(
                Config.checkOverFlow ? Const.OVERFLOW : contact.jobTitle ?? ""),
          ),
          ListTile(
            title: const Text(
                Config.checkOverFlow ? Const.OVERFLOW : "Account Type"),
            trailing: Text((contact.androidAccountType != null)
                ? contact.androidAccountType.toString()
                : ""),
          ),
          addressesTile(contact.postalAddresses!),
          itemsTile("Phones", contact.phones!),
          itemsTile("Emails", contact.emails!)
        ],
      ),
    ),
  );
}

@swidget
Widget addressesTile(List<PostalAddress> addresses) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const ListTile(
          title: Text(Config.checkOverFlow ? Const.OVERFLOW : "Addresses")),
      Column(
        children: [
          for (var a in addresses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text(
                        Config.checkOverFlow ? Const.OVERFLOW : "Street"),
                    trailing: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : a.street ?? ""),
                  ),
                  ListTile(
                    title: const Text(
                        Config.checkOverFlow ? Const.OVERFLOW : "Postcode"),
                    trailing: Text(Config.checkOverFlow
                        ? Const.OVERFLOW
                        : a.postcode ?? ""),
                  ),
                  ListTile(
                    title: const Text(
                        Config.checkOverFlow ? Const.OVERFLOW : "City"),
                    trailing: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : a.city ?? ""),
                  ),
                  ListTile(
                    title: const Text(
                        Config.checkOverFlow ? Const.OVERFLOW : "Region"),
                    trailing: Text(
                        Config.checkOverFlow ? Const.OVERFLOW : a.region ?? ""),
                  ),
                  ListTile(
                    title: const Text(
                        Config.checkOverFlow ? Const.OVERFLOW : "Country"),
                    trailing: Text(Config.checkOverFlow
                        ? Const.OVERFLOW
                        : a.country ?? ""),
                  ),
                ],
              ),
            ),
        ],
      ),
    ],
  );
}

@swidget
Widget itemsTile(String title, List<Item> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      ListTile(title: Text(Config.checkOverFlow ? Const.OVERFLOW : title)),
      Column(
        children: [
          for (var i in items)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title:
                    Text(Config.checkOverFlow ? Const.OVERFLOW : i.label ?? ""),
                trailing:
                    Text(Config.checkOverFlow ? Const.OVERFLOW : i.value ?? ""),
              ),
            ),
        ],
      ),
    ],
  );
}
