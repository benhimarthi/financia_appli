import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '''
## Privacy Policy

Last updated: [Date]

Welcome to [Your App Name] ("us", "we", or "our"). We operate the [Your App Name] mobile application (the "Service").

This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.

### Information Collection and Use

We collect several different types of information for various purposes to provide and improve our Service to you.

#### Personal Data

While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:

* Email address
* First name and last name
* Usage Data

### Use of Data

[Your App Name] uses the collected data for various purposes:

* To provide and maintain the Service
* To notify you about changes to our Service
* To allow you to participate in interactive features of our Service when you choose to do so
* To provide customer care and support
* To provide analysis or valuable information so that we can improve the Service
* To monitor the usage of the Service
* To detect, prevent and address technical issues

### Security of Data

The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.

### Changes to This Privacy Policy

We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the "last updated" date at the top of this Privacy Policy.

### Contact Us

If you have any questions about this Privacy Policy, please contact us:

* By email: [Your Contact Email]
          '''.tr(),
        ),
      ),
    );
  }
}
