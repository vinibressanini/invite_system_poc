import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env{

  @EnviedField(varName: 'FMC_KEY', obfuscate: true)
  static final fmcKey = _Env.fmcKey;

}