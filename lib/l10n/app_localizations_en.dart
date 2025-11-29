// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get iniciarSesion => 'Sign in';

  @override
  String get porFavorVerificaCorreo =>
      'Please verify your email before signing in.';

  @override
  String get credencialesInvalidas => 'Invalid credentials';

  @override
  String get usuarioDeshabilitado => 'User disabled';

  @override
  String get demasiadosIntentos => 'Too many attempts. Try again later.';

  @override
  String get errorRed => 'Network error. Check your connection.';

  @override
  String get errorInesperado => 'Unexpected error. Please try again.';

  @override
  String get debeIngresarCorreo => 'Email is required';

  @override
  String get correoInvalido => 'Invalid email';

  @override
  String get debeIngresarContrasena => 'Password is required';

  @override
  String get emailLabel => 'Email';

  @override
  String get contrasenaLabel => 'Password';

  @override
  String get entrar => 'Sign in';

  @override
  String get yaTenesCuentaIniciaSesion => 'Already have an account? Sign in';

  @override
  String get registrarse => 'Register';

  @override
  String get registroExitosoTitle => 'Registration successful';

  @override
  String get registroExitosoContent =>
      'We\'ve sent a verification email. Please check it to be able to sign in.';

  @override
  String get aceptar => 'Accept';

  @override
  String get confirmarContrasenaLabel => 'Confirm password';

  @override
  String get crearCuenta => 'Create account';

  @override
  String get yaExisteCuenta => 'An account with that email already exists.';

  @override
  String get emailInvalido => 'Invalid email.';

  @override
  String get contrasenaDebil => 'The password is too weak.';

  @override
  String get noSePudoEnviarCorreoVerificacion =>
      'Could not send verification email. Try again later.';

  @override
  String get confirmacionObligatoria => 'Confirmation required';

  @override
  String get contrasenasNoCoinciden => 'Passwords do not match';

  @override
  String get editar => 'Edit';

  @override
  String get eliminar => 'Delete';

  @override
  String get eliminarGastoTitle => 'Delete Expense';

  @override
  String confirmDeleteExpense(Object description) {
    return 'Are you sure you want to delete the expense \'$description\'?';
  }

  @override
  String get cancelar => 'Cancel';

  @override
  String get gastoEliminado => 'Expense deleted';

  @override
  String errorEliminar(Object error) {
    return 'Error: $error';
  }

  @override
  String get expense_edit_title => 'Edit Expense';

  @override
  String get expense_add_title => 'Add Expense';

  @override
  String get expense_description_label => 'Description';

  @override
  String get expense_description_hint => 'E.g.: Fuel';

  @override
  String get expense_description_required => 'Expense description is required';

  @override
  String get expense_amount_label => 'Amount';

  @override
  String get expense_amount_required => 'Expense amount is required';

  @override
  String get expense_date_label => 'Expense date';

  @override
  String get expense_date_required => 'The date is required';

  @override
  String get expense_type_label => 'Expense type';

  @override
  String get expense_type_required => 'Expense type is required';

  @override
  String get expense_save_changes => 'Save changes';

  @override
  String get expense_add => 'Add expense';

  @override
  String get error_not_logged => 'Error: You are not signed in.';

  @override
  String get expense_saved_success => 'Expense saved successfully.';

  @override
  String error_saving(Object error) {
    return 'Error saving: $error';
  }

  @override
  String get expense_added_success => 'Expense added successfully.';

  @override
  String error_adding(Object error) {
    return 'Error adding: $error';
  }

  @override
  String get expense_list_title => 'My Expenses';

  @override
  String get filter_by_date_title => 'Filter by Date';

  @override
  String get date_from_label => 'From:';

  @override
  String get date_to_label => 'To:';

  @override
  String get select_date => 'Select date';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get filter_by_type_title => 'Filter by Type';

  @override
  String get view_all => 'View all';

  @override
  String get filter_by_vehicle_title => 'Filter by Vehicle';

  @override
  String get no_vehicles_registered =>
      'You don\'t have any registered vehicles';

  @override
  String get fechas_label => 'Dates';

  @override
  String get date_start_short => 'Start';

  @override
  String get date_today_label => 'Today';

  @override
  String date_range_from(Object start) {
    return 'From $start';
  }

  @override
  String date_range_to(Object end) {
    return 'To $end';
  }

  @override
  String date_range_between(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get clear_filters_tooltip => 'Clear filters';

  @override
  String get vehicle_label_single => 'Vehicle';

  @override
  String get vehicle_placeholder => 'Vehicle...';

  @override
  String get type_label => 'Type';

  @override
  String get no_expenses_message =>
      'You have no expenses.\nGo to \'My Vehicles\' to add one from your car detail.';

  @override
  String get no_expenses_filtered => 'No expenses found with these filters.';

  @override
  String error_generic(Object error) {
    return 'Error: $error';
  }

  @override
  String get home_title => 'My Vehicles';

  @override
  String get no_vehicles_home => 'You have no vehicles.\nTap (+) to add one.';

  @override
  String get loading => 'Loading...';

  @override
  String get tooltip_expenses => 'Expenses';

  @override
  String get tooltip_add_vehicle => 'Add Vehicle';

  @override
  String get tooltip_settings => 'Settings';

  @override
  String get no_vehicles_centered =>
      'You have no vehicles.\nTap (+) to add one.';

  @override
  String get logout_confirmation_hint => 'Sign out';

  @override
  String get reminders_button_tooltip => 'Reminders';

  @override
  String get insurance_edit_title => 'Edit Insurance';

  @override
  String get insurance_add_title => 'Add Insurance';

  @override
  String get insurance_name_label => 'Insurer';

  @override
  String get insurance_name_required => 'Insurer name is required';

  @override
  String get policy_number_label => 'Policy No.';

  @override
  String get policy_number_required => 'Policy number is required';

  @override
  String get expiration_date_label => 'Expiration date';

  @override
  String get expiration_date_required => 'Expiration date is required';

  @override
  String get coverage_label => 'Coverage type';

  @override
  String get coverage_required => 'Coverage type is required';

  @override
  String get engine_number_label => 'Engine No.';

  @override
  String get engine_number_required => 'Engine number is required';

  @override
  String get chassis_number_label => 'Chassis No.';

  @override
  String get chassis_number_required => 'Chassis number is required';

  @override
  String get policy_holder_label => 'Policy holder';

  @override
  String get policy_holder_required => 'Policy holder name is required';

  @override
  String get policy_document_title => 'Digital Policy Document';

  @override
  String get pick_file_hint => 'Tap to upload Policy (PDF or Photo)';

  @override
  String get current_file_label => 'Current file:';

  @override
  String get file_picker_edit_icon_semantic => 'Edit file';

  @override
  String get save_changes => 'Save changes';

  @override
  String get add_insurance => 'Add insurance';

  @override
  String get insurance_saved_success => 'Insurance saved successfully.';

  @override
  String get insurance_added_success => 'Insurance added successfully.';

  @override
  String get map_title => 'Where did I park?';

  @override
  String get no_car_id => 'No valid car id. Showing current location.';

  @override
  String get location_service_disabled => 'Location service is disabled.';

  @override
  String get location_permission_denied => 'Location permission denied.';

  @override
  String get location_permission_denied_forever =>
      'Location permission denied permanently. Enable it from settings.';

  @override
  String error_getting_location(Object error) {
    return 'Error getting location: $error';
  }

  @override
  String get info_selected_location => 'Selected location';

  @override
  String get info_parked_here => 'Parked here';

  @override
  String get no_location_to_save => 'No location to save. Press Update first.';

  @override
  String error_saving_firestore(Object error) {
    return 'Error saving to Firestore: $error';
  }

  @override
  String error_searching_car(Object error) {
    return 'Error searching car: $error';
  }

  @override
  String marker_title_auto_parked(Object id) {
    return 'Car $id (parked)';
  }

  @override
  String get actualizar_button => 'Update';

  @override
  String get guardar_button => 'Save';

  @override
  String get mostrar_ubicacion_tooltip => 'Show location';

  @override
  String get exact_alarms_permission_title => 'Exact alarms permission';

  @override
  String get exact_alarms_permission_content =>
      'To trigger reminders at the exact time we need you to enable \"Schedule exact alarms\" in your phone settings. Do you want to open settings now?';

  @override
  String get no_button => 'No';

  @override
  String get open_button => 'Open';

  @override
  String get reminder_new_title => 'New reminder';

  @override
  String get reminder_edit_title => 'Edit reminder';

  @override
  String get reminder_field_title_label => 'Title';

  @override
  String get choose_date => 'Choose date';

  @override
  String get choose_time => 'Choose time';

  @override
  String get time_must_be_future => 'The time must be in the future';

  @override
  String get reminder_done_delete => 'Done / Delete';

  @override
  String get reminder_update => 'Update';

  @override
  String get reminder_save => 'Save';

  @override
  String get reminder_deleted_success => 'Reminder deleted';

  @override
  String get reminder_updated_success => 'Reminder updated';

  @override
  String get reminder_created_success => 'Reminder created';

  @override
  String generic_error(Object error) {
    return 'Error: $error';
  }

  @override
  String get appbar_reminders_title => 'My Reminders';

  @override
  String get no_reminders_message =>
      'You have no reminders.\nGo to \'My Vehicles\' to add one from your car detail.';

  @override
  String get vehicle_not_found => 'Vehicle not found';

  @override
  String get vehicle_deleted_message =>
      'Vehicle deleted. Returning to the list...';

  @override
  String error_snapshot(Object error) {
    return 'Error: $error';
  }

  @override
  String get not_available => 'Not available';

  @override
  String get delete_vehicle_button => 'Delete vehicle';

  @override
  String get park_label => 'Park';

  @override
  String get reminders_label => 'Reminders';

  @override
  String get section_vehicle_data => 'VEHICLE DATA';

  @override
  String get edit_vehicle_tooltip => 'Edit vehicle data';

  @override
  String last_update_label(Object date) {
    return 'Last update: $date';
  }

  @override
  String license_plate_label(Object license) {
    return 'License';
  }

  @override
  String brand_label(Object brand) {
    return 'Brand';
  }

  @override
  String model_label(Object model) {
    return 'Model';
  }

  @override
  String year_label(Object year) {
    return 'Year';
  }

  @override
  String engine_label(Object engine) {
    return 'Engine';
  }

  @override
  String transmission_label(Object transmission) {
    return 'Transmission';
  }

  @override
  String get insurance_section_title => 'INSURANCE';

  @override
  String get view_policy_tooltip => 'View circulation card';

  @override
  String get no_file_uploaded => 'No file uploaded.';

  @override
  String get edit_insurance_tooltip => 'Edit insurance data';

  @override
  String get add_insurance_message => 'No insurance associated.';

  @override
  String get add_insurance_button => 'Add Insurance';

  @override
  String get expenses_section_title => 'RECENT EXPENSES';

  @override
  String get add_expense_tooltip => 'Add expense';

  @override
  String get view_expenses_tooltip => 'View vehicle expenses';

  @override
  String get no_expenses_registered => 'No expenses recorded';

  @override
  String get add_expense_button => 'Add Expense';

  @override
  String get generic_delete_success => 'Vehicle created successfully.';

  @override
  String generic_delete_error(Object error) {
    return 'Error creating: $error';
  }

  @override
  String get vehicle_edit_title => 'Edit Vehicle';

  @override
  String get vehicle_add_title => 'Add Vehicle';

  @override
  String get brand_required => 'Please enter the brand';

  @override
  String get model_required => 'Please enter the model';

  @override
  String get year_required => 'Please enter the year';

  @override
  String get year_invalid => 'Enter a valid year';

  @override
  String get license_plate_required => 'Please enter the license plate';

  @override
  String get engine_required => 'Please enter the engine';

  @override
  String get transmission_required => 'Please enter the transmission';

  @override
  String get gallery_option => 'Gallery / File explorer';

  @override
  String get camera_option => 'Camera';

  @override
  String get no_image_selected => 'No image selected.';

  @override
  String get image_load_error => 'Error loading';

  @override
  String get image_picker_gallery_title => 'Gallery / File explorer';

  @override
  String get image_picker_camera_title => 'Camera';

  @override
  String get camera_button_tooltip => 'Open image picker';

  @override
  String get save_changes_button => 'Save changes';

  @override
  String get add_vehicle_button => 'Add vehicle';

  @override
  String get vehicle_saved_success => 'Vehicle saved successfully.';

  @override
  String get vehicle_created_success => 'Vehicle created successfully.';

  @override
  String error_creating(Object error) {
    return 'Error creating: $error';
  }
}
