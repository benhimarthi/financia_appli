enum AccountType { personal, business }

extension AccountTypeExtension on String {
  AccountType toAccountType() {
    switch (this) {
      case 'business':
        return AccountType.business;
      default:
        return AccountType.personal;
    }
  }
}
