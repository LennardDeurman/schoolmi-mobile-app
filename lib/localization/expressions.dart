import 'package:schoolmi/localization/localization.dart';
class Expressions {
  final LocalizationObject votes = LocalizationObject({ Languages.NL: NounForm(plural: "Punten", singular: "Punt")});
  final LocalizationObject answers = LocalizationObject({ Languages.NL: NounForm(plural: "Antwoorden", singular: "Antwoord")});
  final LocalizationObject reactions = LocalizationObject({ Languages.NL: NounForm(plural: "Reacties", singular: "Reactie") });
  final LocalizationObject views = LocalizationObject({ Languages.NL: NounForm(plural: "Weergaven", singular: "Weergave") });
  final LocalizationObject questions = LocalizationObject({ Languages.NL: NounForm(plural: "Vragen", singular: "Vraag") });
  final LocalizationObject attachments = LocalizationObject({ Languages.NL: NounForm(plural: "Bijlagen", singular: "Bijlage")});
  final LocalizationObject members = LocalizationObject({ Languages.NL: NounForm(plural: "Leden", singular: "Lid") });
  final LocalizationObject image = LocalizationObject({ Languages.NL: NounForm(plural: "Afbeeldingen", singular: "Afbeelding")});
  final LocalizationObject otherUsers = LocalizationObject({ Languages.NL: "%s en %s andere gebruiker(s)" });
  final LocalizationObject selectedCount = LocalizationObject({ Languages.NL: "%d geselecteerd" });
  final LocalizationObject resultsRetrievedAt = LocalizationObject({ Languages.NL: "Opgehaald op %s" });
  final LocalizationObject createdOn = LocalizationObject({ Languages.NL: "Geplaatst op "});
  final LocalizationObject by = LocalizationObject({ Languages.NL: " door "});
}
