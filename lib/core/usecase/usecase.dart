import 'package:myapp/core/utils/typedef.dart';

abstract class UseCaseWithParam<type, Param> {
  const UseCaseWithParam();
  ResultFuture<type> call(Param params);
}

abstract class UseCaseWithoutParam<type> {
  const UseCaseWithoutParam();
  ResultFuture<type> call();
}
