import 'package:schoolmi/localization/localization.dart';
class LoginLocalization {
  final LocalizationObject appName = NonTranslateAbleObject("SchoolMi");
  final LocalizationObject login = LocalizationObject({ Languages.NL: "Inloggen" });
  final LocalizationObject register = LocalizationObject({ Languages.NL: "Registreren" });
  final LocalizationObject verifyEmail = LocalizationObject({ Languages.NL: "Email bevestigen" });
  final LocalizationObject socialLogin = LocalizationObject({ Languages.NL: "Social login" });
  final LocalizationObject noAccount = LocalizationObject({ Languages.NL: "Nog geen account?" });
  final LocalizationObject alreadyAccount = LocalizationObject({ Languages.NL: "Al een account?" });
  final LocalizationObject emailVerified = LocalizationObject({ Languages.NL: "E-mail bevestigd?" });
  final LocalizationObject verifyEmailDescription = LocalizationObject({ Languages.NL: "Wij hebben je een email verstuurd om je account te bevestigen. Bevestig je e-mail en log dan in.\n\nGeen email gekregen? Controleer je spam." });
  final LocalizationObject next = LocalizationObject({ Languages.NL: "Volgende" });
  final LocalizationObject image = LocalizationObject({ Languages.NL: "Afbeelding" });
  final LocalizationObject firstName = LocalizationObject({ Languages.NL: "Voornaam" });
  final LocalizationObject firstNameHint = LocalizationObject({ Languages.NL: "bv. Lennard" });
  final LocalizationObject lastName = LocalizationObject({ Languages.NL: "Achternaam" });
  final LocalizationObject lastNameHint = LocalizationObject({ Languages.NL: "bv. Deurman" });
  final LocalizationObject email = LocalizationObject({ Languages.NL: "E-mail" });
  final LocalizationObject emailHint = LocalizationObject({ Languages.NL: "bv. naam@email.com" });
  final LocalizationObject password = LocalizationObject({ Languages.NL: "Wachtwoord" });
  final LocalizationObject passwordHint = LocalizationObject({ Languages.NL: "••••••••••" });
  final LocalizationObject forgotPassword = LocalizationObject({ Languages.NL: "Wachtwoord vergeten?" });
  final LocalizationObject resetEmailSent = LocalizationObject({ Languages.NL: "Herstelemail verstuurd"});
  final LocalizationObject resetEmailDescription = LocalizationObject( {
    Languages.NL: "Wij hebben je een email verstuurd om je wachtwoord te herstellen. Stel via deze mail je wachtwoord online opnieuw in en keer dan terug naar de app.\n\nGeen email gekregen? Controleer je spam. "
  });

}