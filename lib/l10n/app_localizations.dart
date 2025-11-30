import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @language_es.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get language_es;

  /// No description provided for @language_en.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get language_en;

  /// No description provided for @language_pt.
  ///
  /// In es, this message translates to:
  /// **'Portugués'**
  String get language_pt;

  /// No description provided for @select_language.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Idioma'**
  String get select_language;

  /// No description provided for @language_label.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language_label;

  /// No description provided for @settings_general_section.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get settings_general_section;

  /// No description provided for @settings_notifications_section.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get settings_notifications_section;

  /// No description provided for @settings_permissions_section.
  ///
  /// In es, this message translates to:
  /// **'Permisos y Sistema'**
  String get settings_permissions_section;

  /// No description provided for @settings_info_section.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get settings_info_section;

  /// No description provided for @settings_receive_notifications.
  ///
  /// In es, this message translates to:
  /// **'Recibir notificaciones'**
  String get settings_receive_notifications;

  /// No description provided for @settings_camera_permission.
  ///
  /// In es, this message translates to:
  /// **'Acceso a Cámara'**
  String get settings_camera_permission;

  /// No description provided for @settings_system_settings.
  ///
  /// In es, this message translates to:
  /// **'Abrir configuración del sistema'**
  String get settings_system_settings;

  /// No description provided for @settings_version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get settings_version;

  /// No description provided for @iniciarSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get iniciarSesion;

  /// No description provided for @porFavorVerificaCorreo.
  ///
  /// In es, this message translates to:
  /// **'Por favor, verifica tu correo antes de iniciar sesión.'**
  String get porFavorVerificaCorreo;

  /// No description provided for @credencialesInvalidas.
  ///
  /// In es, this message translates to:
  /// **'Credenciales inválidas'**
  String get credencialesInvalidas;

  /// No description provided for @usuarioDeshabilitado.
  ///
  /// In es, this message translates to:
  /// **'Usuario deshabilitado'**
  String get usuarioDeshabilitado;

  /// No description provided for @demasiadosIntentos.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Probá más tarde.'**
  String get demasiadosIntentos;

  /// No description provided for @errorRed.
  ///
  /// In es, this message translates to:
  /// **'Error de red. Verificá tu conexión.'**
  String get errorRed;

  /// No description provided for @errorInesperado.
  ///
  /// In es, this message translates to:
  /// **'Error inesperado'**
  String get errorInesperado;

  /// No description provided for @debeIngresarCorreo.
  ///
  /// In es, this message translates to:
  /// **'Debe ingresar correo'**
  String get debeIngresarCorreo;

  /// No description provided for @correoInvalido.
  ///
  /// In es, this message translates to:
  /// **'Correo inválido'**
  String get correoInvalido;

  /// No description provided for @debeIngresarContrasena.
  ///
  /// In es, this message translates to:
  /// **'Debe ingresar contraseña'**
  String get debeIngresarContrasena;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @contrasenaLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get contrasenaLabel;

  /// No description provided for @entrar.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get entrar;

  /// No description provided for @yaTenesCuentaIniciaSesion.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tenes una cuenta? Inicia sesión'**
  String get yaTenesCuentaIniciaSesion;

  /// No description provided for @registrarse.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registrarse;

  /// No description provided for @registroExitosoTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro exitoso'**
  String get registroExitosoTitle;

  /// No description provided for @registroExitosoContent.
  ///
  /// In es, this message translates to:
  /// **'Te enviamos un correo de verificación. Por favor, revísalo para poder iniciar sesión.'**
  String get registroExitosoContent;

  /// No description provided for @aceptar.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get aceptar;

  /// No description provided for @confirmarContrasenaLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmarContrasenaLabel;

  /// No description provided for @crearCuenta.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get crearCuenta;

  /// No description provided for @yaExisteCuenta.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con ese correo.'**
  String get yaExisteCuenta;

  /// No description provided for @emailInvalido.
  ///
  /// In es, this message translates to:
  /// **'Email inválido.'**
  String get emailInvalido;

  /// No description provided for @contrasenaDebil.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es demasiado débil.'**
  String get contrasenaDebil;

  /// No description provided for @noSePudoEnviarCorreoVerificacion.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar el correo de verificación. Inténtalo de nuevo más tarde.'**
  String get noSePudoEnviarCorreoVerificacion;

  /// No description provided for @confirmacionObligatoria.
  ///
  /// In es, this message translates to:
  /// **'Confirmación obligatoria'**
  String get confirmacionObligatoria;

  /// No description provided for @contrasenasNoCoinciden.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get contrasenasNoCoinciden;

  /// No description provided for @editar.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editar;

  /// No description provided for @eliminar.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get eliminar;

  /// No description provided for @eliminarGastoTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Gasto'**
  String get eliminarGastoTitle;

  /// No description provided for @confirmDeleteExpense.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar el gasto \'{description}\'?'**
  String confirmDeleteExpense(Object description);

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @gastoEliminado.
  ///
  /// In es, this message translates to:
  /// **'Gasto eliminado'**
  String get gastoEliminado;

  /// No description provided for @errorEliminar.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String errorEliminar(Object error);

  /// No description provided for @expense_edit_title.
  ///
  /// In es, this message translates to:
  /// **'Editar Gasto'**
  String get expense_edit_title;

  /// No description provided for @expense_add_title.
  ///
  /// In es, this message translates to:
  /// **'Añadir Gasto'**
  String get expense_add_title;

  /// No description provided for @expense_description_label.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get expense_description_label;

  /// No description provided for @expense_description_hint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Combustible'**
  String get expense_description_hint;

  /// No description provided for @expense_description_required.
  ///
  /// In es, this message translates to:
  /// **'La descripción del gasto es obligatoria'**
  String get expense_description_required;

  /// No description provided for @expense_amount_label.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get expense_amount_label;

  /// No description provided for @expense_amount_required.
  ///
  /// In es, this message translates to:
  /// **'El monto del gasto es obligatorio'**
  String get expense_amount_required;

  /// No description provided for @expense_date_label.
  ///
  /// In es, this message translates to:
  /// **'Fecha del gasto'**
  String get expense_date_label;

  /// No description provided for @expense_date_required.
  ///
  /// In es, this message translates to:
  /// **'La fecha de expiración es obligatoria'**
  String get expense_date_required;

  /// No description provided for @expense_type_label.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Gasto'**
  String get expense_type_label;

  /// No description provided for @expense_type_required.
  ///
  /// In es, this message translates to:
  /// **'El tipo de gasto es obligatorio'**
  String get expense_type_required;

  /// No description provided for @expense_save_changes.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get expense_save_changes;

  /// No description provided for @expense_add.
  ///
  /// In es, this message translates to:
  /// **'Añadir gasto'**
  String get expense_add;

  /// No description provided for @error_not_logged.
  ///
  /// In es, this message translates to:
  /// **'Error: No has iniciado sesión.'**
  String get error_not_logged;

  /// No description provided for @expense_saved_success.
  ///
  /// In es, this message translates to:
  /// **'Gasto guardado con éxito.'**
  String get expense_saved_success;

  /// No description provided for @error_saving.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String error_saving(Object error);

  /// No description provided for @expense_added_success.
  ///
  /// In es, this message translates to:
  /// **'Gasto añadido con éxito.'**
  String get expense_added_success;

  /// No description provided for @error_adding.
  ///
  /// In es, this message translates to:
  /// **'Error al añadir: {error}'**
  String error_adding(Object error);

  /// No description provided for @expense_list_title.
  ///
  /// In es, this message translates to:
  /// **'Mis Gastos'**
  String get expense_list_title;

  /// No description provided for @filter_by_date_title.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por Fecha'**
  String get filter_by_date_title;

  /// No description provided for @date_from_label.
  ///
  /// In es, this message translates to:
  /// **'Desde:'**
  String get date_from_label;

  /// No description provided for @date_to_label.
  ///
  /// In es, this message translates to:
  /// **'Hasta:'**
  String get date_to_label;

  /// No description provided for @select_date.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get select_date;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @filter_by_type_title.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por Tipo'**
  String get filter_by_type_title;

  /// No description provided for @view_all.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get view_all;

  /// No description provided for @filter_by_vehicle_title.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por Vehículo'**
  String get filter_by_vehicle_title;

  /// No description provided for @no_vehicles_registered.
  ///
  /// In es, this message translates to:
  /// **'No tienes vehículos registrados'**
  String get no_vehicles_registered;

  /// No description provided for @fechas_label.
  ///
  /// In es, this message translates to:
  /// **'Fechas'**
  String get fechas_label;

  /// No description provided for @date_start_short.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get date_start_short;

  /// No description provided for @date_today_label.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get date_today_label;

  /// No description provided for @date_range_from.
  ///
  /// In es, this message translates to:
  /// **'Desde {start}'**
  String date_range_from(Object start);

  /// No description provided for @date_range_to.
  ///
  /// In es, this message translates to:
  /// **'Hasta {end}'**
  String date_range_to(Object end);

  /// No description provided for @date_range_between.
  ///
  /// In es, this message translates to:
  /// **'{start} - {end}'**
  String date_range_between(Object start, Object end);

  /// No description provided for @clear_filters_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get clear_filters_tooltip;

  /// No description provided for @vehicle_label_single.
  ///
  /// In es, this message translates to:
  /// **'Vehículo'**
  String get vehicle_label_single;

  /// No description provided for @vehicle_placeholder.
  ///
  /// In es, this message translates to:
  /// **'Vehículo...'**
  String get vehicle_placeholder;

  /// No description provided for @type_label.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get type_label;

  /// No description provided for @no_expenses_message.
  ///
  /// In es, this message translates to:
  /// **'No tienes gastos.\nVe a la sección \'Mis Vehículos\' para añadir uno desde el detalle de tu auto.'**
  String get no_expenses_message;

  /// No description provided for @no_expenses_filtered.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron gastos con estos filtros.'**
  String get no_expenses_filtered;

  /// No description provided for @error_generic.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String error_generic(Object error);

  /// No description provided for @home_title.
  ///
  /// In es, this message translates to:
  /// **'Mis Vehículos'**
  String get home_title;

  /// No description provided for @no_vehicles_home.
  ///
  /// In es, this message translates to:
  /// **'No tienes vehículos.\nPresiona (+) para añadir uno.'**
  String get no_vehicles_home;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @tooltip_expenses.
  ///
  /// In es, this message translates to:
  /// **'Gastos'**
  String get tooltip_expenses;

  /// No description provided for @tooltip_add_vehicle.
  ///
  /// In es, this message translates to:
  /// **'Añadir Vehículo'**
  String get tooltip_add_vehicle;

  /// No description provided for @tooltip_settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get tooltip_settings;

  /// No description provided for @no_vehicles_centered.
  ///
  /// In es, this message translates to:
  /// **'No tienes vehículos.\nPresiona (+) para añadir uno.'**
  String get no_vehicles_centered;

  /// No description provided for @logout_confirmation_hint.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout_confirmation_hint;

  /// No description provided for @reminders_button_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios'**
  String get reminders_button_tooltip;

  /// No description provided for @insurance_edit_title.
  ///
  /// In es, this message translates to:
  /// **'Editar Seguro'**
  String get insurance_edit_title;

  /// No description provided for @insurance_add_title.
  ///
  /// In es, this message translates to:
  /// **'Añadir Seguro'**
  String get insurance_add_title;

  /// No description provided for @insurance_name_label.
  ///
  /// In es, this message translates to:
  /// **'Aseguradora'**
  String get insurance_name_label;

  /// No description provided for @insurance_name_required.
  ///
  /// In es, this message translates to:
  /// **'El nombre de la aseguradora es obligatorio'**
  String get insurance_name_required;

  /// No description provided for @policy_number_label.
  ///
  /// In es, this message translates to:
  /// **'N° de póliza'**
  String get policy_number_label;

  /// No description provided for @policy_number_required.
  ///
  /// In es, this message translates to:
  /// **'El N° de póliza es obligatorio'**
  String get policy_number_required;

  /// No description provided for @expiration_date_label.
  ///
  /// In es, this message translates to:
  /// **'Fecha de expiración'**
  String get expiration_date_label;

  /// No description provided for @expiration_date_required.
  ///
  /// In es, this message translates to:
  /// **'La fecha de expiración es obligatoria'**
  String get expiration_date_required;

  /// No description provided for @coverage_label.
  ///
  /// In es, this message translates to:
  /// **'Tipo de cobertura'**
  String get coverage_label;

  /// No description provided for @coverage_required.
  ///
  /// In es, this message translates to:
  /// **'El tipo de cobertura es obligatorio'**
  String get coverage_required;

  /// No description provided for @engine_number_label.
  ///
  /// In es, this message translates to:
  /// **'N° de motor'**
  String get engine_number_label;

  /// No description provided for @engine_number_required.
  ///
  /// In es, this message translates to:
  /// **'El N° de motor es obligatorio'**
  String get engine_number_required;

  /// No description provided for @chassis_number_label.
  ///
  /// In es, this message translates to:
  /// **'N° de chasis'**
  String get chassis_number_label;

  /// No description provided for @chassis_number_required.
  ///
  /// In es, this message translates to:
  /// **'El N° de chasis es obligatorio'**
  String get chassis_number_required;

  /// No description provided for @policy_holder_label.
  ///
  /// In es, this message translates to:
  /// **'Titular'**
  String get policy_holder_label;

  /// No description provided for @policy_holder_required.
  ///
  /// In es, this message translates to:
  /// **'El nombre del titular es obligatorio'**
  String get policy_holder_required;

  /// No description provided for @policy_document_title.
  ///
  /// In es, this message translates to:
  /// **'Comprobante de Póliza Digital'**
  String get policy_document_title;

  /// No description provided for @pick_file_hint.
  ///
  /// In es, this message translates to:
  /// **'Tocar para subir Póliza (PDF o Foto)'**
  String get pick_file_hint;

  /// No description provided for @current_file_label.
  ///
  /// In es, this message translates to:
  /// **'Archivo actual:'**
  String get current_file_label;

  /// No description provided for @file_picker_edit_icon_semantic.
  ///
  /// In es, this message translates to:
  /// **'Editar archivo'**
  String get file_picker_edit_icon_semantic;

  /// No description provided for @save_changes.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get save_changes;

  /// No description provided for @add_insurance.
  ///
  /// In es, this message translates to:
  /// **'Añadir seguro'**
  String get add_insurance;

  /// No description provided for @insurance_saved_success.
  ///
  /// In es, this message translates to:
  /// **'Seguro guardado con éxito.'**
  String get insurance_saved_success;

  /// No description provided for @insurance_added_success.
  ///
  /// In es, this message translates to:
  /// **'Seguro añadido con éxito.'**
  String get insurance_added_success;

  /// No description provided for @map_title.
  ///
  /// In es, this message translates to:
  /// **'¿Donde Estacione?'**
  String get map_title;

  /// No description provided for @no_car_id.
  ///
  /// In es, this message translates to:
  /// **'No hay id de auto válido. Mostrando ubicación actual.'**
  String get no_car_id;

  /// No description provided for @location_service_disabled.
  ///
  /// In es, this message translates to:
  /// **'El servicio de ubicación está desactivado.'**
  String get location_service_disabled;

  /// No description provided for @location_permission_denied.
  ///
  /// In es, this message translates to:
  /// **'Permiso de ubicación denegado.'**
  String get location_permission_denied;

  /// No description provided for @location_permission_denied_forever.
  ///
  /// In es, this message translates to:
  /// **'Permiso de ubicación denegado permanentemente. Habilitalo desde ajustes.'**
  String get location_permission_denied_forever;

  /// No description provided for @error_getting_location.
  ///
  /// In es, this message translates to:
  /// **'Error al obtener ubicación: {error}'**
  String error_getting_location(Object error);

  /// No description provided for @info_selected_location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación seleccionada'**
  String get info_selected_location;

  /// No description provided for @info_parked_here.
  ///
  /// In es, this message translates to:
  /// **'Estacionado aquí'**
  String get info_parked_here;

  /// No description provided for @no_location_to_save.
  ///
  /// In es, this message translates to:
  /// **'No hay ubicación para guardar. Presiona Actualizar primero.'**
  String get no_location_to_save;

  /// No description provided for @error_saving_firestore.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar en Firestore: {error}'**
  String error_saving_firestore(Object error);

  /// No description provided for @error_searching_car.
  ///
  /// In es, this message translates to:
  /// **'Error buscando el auto: {error}'**
  String error_searching_car(Object error);

  /// No description provided for @marker_title_auto_parked.
  ///
  /// In es, this message translates to:
  /// **'Auto {id} (parked)'**
  String marker_title_auto_parked(Object id);

  /// No description provided for @actualizar_button.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get actualizar_button;

  /// No description provided for @guardar_button.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get guardar_button;

  /// No description provided for @mostrar_ubicacion_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Mostrar ubicación'**
  String get mostrar_ubicacion_tooltip;

  /// No description provided for @exact_alarms_permission_title.
  ///
  /// In es, this message translates to:
  /// **'Permiso para alarmas exactas'**
  String get exact_alarms_permission_title;

  /// No description provided for @exact_alarms_permission_content.
  ///
  /// In es, this message translates to:
  /// **'Para que los recordatorios se desencadenen a la hora exacta necesitamos que actives \"Programar alarmas exactas\" en la configuración del teléfono. ¿Querés abrir la configuración ahora?'**
  String get exact_alarms_permission_content;

  /// No description provided for @no_button.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no_button;

  /// No description provided for @open_button.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get open_button;

  /// No description provided for @reminder_new_title.
  ///
  /// In es, this message translates to:
  /// **'Nuevo recordatorio'**
  String get reminder_new_title;

  /// No description provided for @reminder_edit_title.
  ///
  /// In es, this message translates to:
  /// **'Editar recordatorio'**
  String get reminder_edit_title;

  /// No description provided for @reminder_field_title_label.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get reminder_field_title_label;

  /// No description provided for @choose_date.
  ///
  /// In es, this message translates to:
  /// **'Elegir fecha'**
  String get choose_date;

  /// No description provided for @choose_time.
  ///
  /// In es, this message translates to:
  /// **'Elegir hora'**
  String get choose_time;

  /// No description provided for @time_must_be_future.
  ///
  /// In es, this message translates to:
  /// **'La hora debe ser futura'**
  String get time_must_be_future;

  /// No description provided for @reminder_done_delete.
  ///
  /// In es, this message translates to:
  /// **'Realizado / Eliminar'**
  String get reminder_done_delete;

  /// No description provided for @reminder_update.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get reminder_update;

  /// No description provided for @reminder_save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get reminder_save;

  /// No description provided for @reminder_deleted_success.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio eliminado'**
  String get reminder_deleted_success;

  /// No description provided for @reminder_updated_success.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio actualizado'**
  String get reminder_updated_success;

  /// No description provided for @reminder_created_success.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio creado'**
  String get reminder_created_success;

  /// No description provided for @generic_error.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String generic_error(Object error);

  /// No description provided for @appbar_reminders_title.
  ///
  /// In es, this message translates to:
  /// **'Mis Recordatorios'**
  String get appbar_reminders_title;

  /// No description provided for @no_reminders_message.
  ///
  /// In es, this message translates to:
  /// **'No tienes recordatorios.\nVe a la sección \'Mis Vehículos\' para añadir uno desde el detalle de tu auto.'**
  String get no_reminders_message;

  /// No description provided for @vehicle_not_found.
  ///
  /// In es, this message translates to:
  /// **'Vehículo no encontrado'**
  String get vehicle_not_found;

  /// No description provided for @vehicle_deleted_message.
  ///
  /// In es, this message translates to:
  /// **'Vehículo eliminado. Volviendo a la lista...'**
  String get vehicle_deleted_message;

  /// No description provided for @error_snapshot.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String error_snapshot(Object error);

  /// No description provided for @not_available.
  ///
  /// In es, this message translates to:
  /// **'No disponible'**
  String get not_available;

  /// No description provided for @delete_vehicle_button.
  ///
  /// In es, this message translates to:
  /// **'Eliminar vehículo'**
  String get delete_vehicle_button;

  /// No description provided for @park_label.
  ///
  /// In es, this message translates to:
  /// **'Estacionar'**
  String get park_label;

  /// No description provided for @reminders_label.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios'**
  String get reminders_label;

  /// No description provided for @section_vehicle_data.
  ///
  /// In es, this message translates to:
  /// **'DATOS DEL VEHÍCULO'**
  String get section_vehicle_data;

  /// No description provided for @edit_vehicle_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar datos del vehículo'**
  String get edit_vehicle_tooltip;

  /// No description provided for @insurance_section_title.
  ///
  /// In es, this message translates to:
  /// **'SEGURO'**
  String get insurance_section_title;

  /// No description provided for @view_policy_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Ver tarjeta circulación'**
  String get view_policy_tooltip;

  /// No description provided for @no_file_uploaded.
  ///
  /// In es, this message translates to:
  /// **'No hay un archivo cargado.'**
  String get no_file_uploaded;

  /// No description provided for @edit_insurance_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Editar datos seguro'**
  String get edit_insurance_tooltip;

  /// No description provided for @add_insurance_message.
  ///
  /// In es, this message translates to:
  /// **'No hay un seguro asociado.'**
  String get add_insurance_message;

  /// No description provided for @add_insurance_button.
  ///
  /// In es, this message translates to:
  /// **'Agregar Seguro'**
  String get add_insurance_button;

  /// No description provided for @expenses_section_title.
  ///
  /// In es, this message translates to:
  /// **'GASTOS RECIENTES'**
  String get expenses_section_title;

  /// No description provided for @add_expense_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Añadir gasto'**
  String get add_expense_tooltip;

  /// No description provided for @view_expenses_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Ver gastos del vehículo'**
  String get view_expenses_tooltip;

  /// No description provided for @no_expenses_registered.
  ///
  /// In es, this message translates to:
  /// **'Ningún gasto registrado'**
  String get no_expenses_registered;

  /// No description provided for @add_expense_button.
  ///
  /// In es, this message translates to:
  /// **'Agregar Gasto'**
  String get add_expense_button;

  /// No description provided for @generic_delete_success.
  ///
  /// In es, this message translates to:
  /// **'Vehículo creado con éxito.'**
  String get generic_delete_success;

  /// No description provided for @generic_delete_error.
  ///
  /// In es, this message translates to:
  /// **'Error al crear: {error}'**
  String generic_delete_error(Object error);

  /// No description provided for @vehicle_edit_title.
  ///
  /// In es, this message translates to:
  /// **'Editar Vehículo'**
  String get vehicle_edit_title;

  /// No description provided for @vehicle_add_title.
  ///
  /// In es, this message translates to:
  /// **'Añadir Vehículo'**
  String get vehicle_add_title;

  /// No description provided for @last_update_label.
  ///
  /// In es, this message translates to:
  /// **'Última actualización'**
  String get last_update_label;

  /// No description provided for @brand_label.
  ///
  /// In es, this message translates to:
  /// **'Marca'**
  String get brand_label;

  /// No description provided for @model_label.
  ///
  /// In es, this message translates to:
  /// **'Modelo'**
  String get model_label;

  /// No description provided for @year_label.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get year_label;

  /// No description provided for @license_plate_label.
  ///
  /// In es, this message translates to:
  /// **'Patente'**
  String get license_plate_label;

  /// No description provided for @engine_label.
  ///
  /// In es, this message translates to:
  /// **'Motor'**
  String get engine_label;

  /// No description provided for @transmission_label.
  ///
  /// In es, this message translates to:
  /// **'Transmisión'**
  String get transmission_label;

  /// No description provided for @brand_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa la marca'**
  String get brand_required;

  /// No description provided for @model_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa el modelo'**
  String get model_required;

  /// No description provided for @year_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa el año'**
  String get year_required;

  /// No description provided for @year_invalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un año válido'**
  String get year_invalid;

  /// No description provided for @license_plate_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa la patente'**
  String get license_plate_required;

  /// No description provided for @engine_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa el motor'**
  String get engine_required;

  /// No description provided for @transmission_required.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa la transmisión'**
  String get transmission_required;

  /// No description provided for @gallery_option.
  ///
  /// In es, this message translates to:
  /// **'Galería / Explorador de archivos'**
  String get gallery_option;

  /// No description provided for @camera_option.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get camera_option;

  /// No description provided for @no_image_selected.
  ///
  /// In es, this message translates to:
  /// **'Ninguna imagen seleccionada.'**
  String get no_image_selected;

  /// No description provided for @image_load_error.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get image_load_error;

  /// No description provided for @image_picker_gallery_title.
  ///
  /// In es, this message translates to:
  /// **'Galería / Explorador de archivos'**
  String get image_picker_gallery_title;

  /// No description provided for @image_picker_camera_title.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get image_picker_camera_title;

  /// No description provided for @camera_button_tooltip.
  ///
  /// In es, this message translates to:
  /// **'Abrir selector de imagen'**
  String get camera_button_tooltip;

  /// No description provided for @save_changes_button.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get save_changes_button;

  /// No description provided for @add_vehicle_button.
  ///
  /// In es, this message translates to:
  /// **'Añadir vehículo'**
  String get add_vehicle_button;

  /// No description provided for @vehicle_saved_success.
  ///
  /// In es, this message translates to:
  /// **'Vehículo guardado con éxito.'**
  String get vehicle_saved_success;

  /// No description provided for @vehicle_created_success.
  ///
  /// In es, this message translates to:
  /// **'Vehículo creado con éxito.'**
  String get vehicle_created_success;

  /// No description provided for @error_creating.
  ///
  /// In es, this message translates to:
  /// **'Error al crear: {error}'**
  String error_creating(Object error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
