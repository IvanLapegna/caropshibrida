// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language_es => 'Español';

  @override
  String get language_en => 'Inglés';

  @override
  String get language_pt => 'Portugués';

  @override
  String get select_language => 'Seleccionar Idioma';

  @override
  String get language_label => 'Idioma';

  @override
  String get settings_general_section => 'General';

  @override
  String get settings_notifications_section => 'Notificaciones';

  @override
  String get settings_permissions_section => 'Permisos y Sistema';

  @override
  String get settings_info_section => 'Información';

  @override
  String get settings_receive_notifications => 'Recibir notificaciones';

  @override
  String get settings_camera_permission => 'Acceso a Cámara';

  @override
  String get settings_system_settings => 'Abrir configuración del sistema';

  @override
  String get settings_version => 'Versión';

  @override
  String get iniciarSesion => 'Iniciar sesión';

  @override
  String get porFavorVerificaCorreo =>
      'Por favor, verifica tu correo antes de iniciar sesión.';

  @override
  String get credencialesInvalidas => 'Credenciales inválidas';

  @override
  String get usuarioDeshabilitado => 'Usuario deshabilitado';

  @override
  String get demasiadosIntentos => 'Demasiados intentos. Probá más tarde.';

  @override
  String get errorRed => 'Error de red. Verificá tu conexión.';

  @override
  String get errorInesperado => 'Error inesperado';

  @override
  String get debeIngresarCorreo => 'Debe ingresar correo';

  @override
  String get correoInvalido => 'Correo inválido';

  @override
  String get debeIngresarContrasena => 'Debe ingresar contraseña';

  @override
  String get emailLabel => 'Email';

  @override
  String get contrasenaLabel => 'Contraseña';

  @override
  String get entrar => 'Entrar';

  @override
  String get yaTenesCuentaIniciaSesion => '¿Ya tenes una cuenta? Inicia sesión';

  @override
  String get registrarse => 'Registrarse';

  @override
  String get registroExitosoTitle => 'Registro exitoso';

  @override
  String get registroExitosoContent =>
      'Te enviamos un correo de verificación. Por favor, revísalo para poder iniciar sesión.';

  @override
  String get aceptar => 'Aceptar';

  @override
  String get confirmarContrasenaLabel => 'Confirmar contraseña';

  @override
  String get crearCuenta => 'Crear cuenta';

  @override
  String get yaExisteCuenta => 'Ya existe una cuenta con ese correo.';

  @override
  String get emailInvalido => 'Email inválido.';

  @override
  String get contrasenaDebil => 'La contraseña es demasiado débil.';

  @override
  String get noSePudoEnviarCorreoVerificacion =>
      'No se pudo enviar el correo de verificación. Inténtalo de nuevo más tarde.';

  @override
  String get confirmacionObligatoria => 'Confirmación obligatoria';

  @override
  String get contrasenasNoCoinciden => 'Las contraseñas no coinciden';

  @override
  String get editar => 'Editar';

  @override
  String get eliminar => 'Eliminar';

  @override
  String get eliminarGastoTitle => 'Eliminar Gasto';

  @override
  String confirmDeleteExpense(Object description) {
    return '¿Seguro que quieres eliminar el gasto \'$description\'?';
  }

  @override
  String get cancelar => 'Cancelar';

  @override
  String get gastoEliminado => 'Gasto eliminado';

  @override
  String errorEliminar(Object error) {
    return 'Error: $error';
  }

  @override
  String get expense_edit_title => 'Editar Gasto';

  @override
  String get expense_add_title => 'Añadir Gasto';

  @override
  String get expense_description_label => 'Descripción';

  @override
  String get expense_description_hint => 'Ej: Combustible';

  @override
  String get expense_description_required =>
      'La descripción del gasto es obligatoria';

  @override
  String get expense_amount_label => 'Monto';

  @override
  String get expense_amount_required => 'El monto del gasto es obligatorio';

  @override
  String get expense_date_label => 'Fecha del gasto';

  @override
  String get expense_date_required => 'La fecha de expiración es obligatoria';

  @override
  String get expense_type_label => 'Tipo de Gasto';

  @override
  String get expense_type_required => 'El tipo de gasto es obligatorio';

  @override
  String get expense_save_changes => 'Guardar cambios';

  @override
  String get expense_add => 'Añadir gasto';

  @override
  String get error_not_logged => 'Error: No has iniciado sesión.';

  @override
  String get expense_saved_success => 'Gasto guardado con éxito.';

  @override
  String error_saving(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get expense_added_success => 'Gasto añadido con éxito.';

  @override
  String error_adding(Object error) {
    return 'Error al añadir: $error';
  }

  @override
  String get expense_list_title => 'Mis Gastos';

  @override
  String get filter_by_date_title => 'Filtrar por Fecha';

  @override
  String get date_from_label => 'Desde:';

  @override
  String get date_to_label => 'Hasta:';

  @override
  String get select_date => 'Seleccionar fecha';

  @override
  String get cancel => 'Cancelar';

  @override
  String get apply => 'Aplicar';

  @override
  String get filter_by_type_title => 'Filtrar por Tipo';

  @override
  String get view_all => 'Ver todos';

  @override
  String get filter_by_vehicle_title => 'Filtrar por Vehículo';

  @override
  String get no_vehicles_registered => 'No tienes vehículos registrados';

  @override
  String get fechas_label => 'Fechas';

  @override
  String get date_start_short => 'Inicio';

  @override
  String get date_today_label => 'Hoy';

  @override
  String date_range_from(Object start) {
    return 'Desde $start';
  }

  @override
  String date_range_to(Object end) {
    return 'Hasta $end';
  }

  @override
  String date_range_between(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get clear_filters_tooltip => 'Limpiar filtros';

  @override
  String get vehicle_label_single => 'Vehículo';

  @override
  String get vehicle_placeholder => 'Vehículo...';

  @override
  String get type_label => 'Tipo';

  @override
  String get no_expenses_message =>
      'No tienes gastos.\nVe a la sección \'Mis Vehículos\' para añadir uno desde el detalle de tu auto.';

  @override
  String get no_expenses_filtered =>
      'No se encontraron gastos con estos filtros.';

  @override
  String error_generic(Object error) {
    return 'Error: $error';
  }

  @override
  String get home_title => 'Mis Vehículos';

  @override
  String get no_vehicles_home =>
      'No tienes vehículos.\nPresiona (+) para añadir uno.';

  @override
  String get loading => 'Cargando...';

  @override
  String get tooltip_expenses => 'Gastos';

  @override
  String get tooltip_add_vehicle => 'Añadir Vehículo';

  @override
  String get tooltip_settings => 'Ajustes';

  @override
  String get no_vehicles_centered =>
      'No tienes vehículos.\nPresiona (+) para añadir uno.';

  @override
  String get logout_confirmation_hint => 'Cerrar sesión';

  @override
  String get reminders_button_tooltip => 'Recordatorios';

  @override
  String get insurance_edit_title => 'Editar Seguro';

  @override
  String get insurance_add_title => 'Añadir Seguro';

  @override
  String get insurance_name_label => 'Aseguradora';

  @override
  String get insurance_name_required =>
      'El nombre de la aseguradora es obligatorio';

  @override
  String get policy_number_label => 'N° de póliza';

  @override
  String get policy_number_required => 'El N° de póliza es obligatorio';

  @override
  String get expiration_date_label => 'Fecha de expiración';

  @override
  String get expiration_date_required =>
      'La fecha de expiración es obligatoria';

  @override
  String get coverage_label => 'Tipo de cobertura';

  @override
  String get coverage_required => 'El tipo de cobertura es obligatorio';

  @override
  String get engine_number_label => 'N° de motor';

  @override
  String get engine_number_required => 'El N° de motor es obligatorio';

  @override
  String get chassis_number_label => 'N° de chasis';

  @override
  String get chassis_number_required => 'El N° de chasis es obligatorio';

  @override
  String get policy_holder_label => 'Titular';

  @override
  String get policy_holder_required => 'El nombre del titular es obligatorio';

  @override
  String get policy_document_title => 'Comprobante de Póliza Digital';

  @override
  String get pick_file_hint => 'Tocar para subir Póliza (PDF o Foto)';

  @override
  String get current_file_label => 'Archivo actual:';

  @override
  String get file_picker_edit_icon_semantic => 'Editar archivo';

  @override
  String get save_changes => 'Guardar cambios';

  @override
  String get add_insurance => 'Añadir seguro';

  @override
  String get insurance_saved_success => 'Seguro guardado con éxito.';

  @override
  String get insurance_added_success => 'Seguro añadido con éxito.';

  @override
  String get map_title => '¿Donde Estacione?';

  @override
  String get no_car_id =>
      'No hay id de auto válido. Mostrando ubicación actual.';

  @override
  String get location_service_disabled =>
      'El servicio de ubicación está desactivado.';

  @override
  String get location_permission_denied => 'Permiso de ubicación denegado.';

  @override
  String get location_permission_denied_forever =>
      'Permiso de ubicación denegado permanentemente. Habilitalo desde ajustes.';

  @override
  String error_getting_location(Object error) {
    return 'Error al obtener ubicación: $error';
  }

  @override
  String get info_selected_location => 'Ubicación seleccionada';

  @override
  String get info_parked_here => 'Estacionado aquí';

  @override
  String get no_location_to_save =>
      'No hay ubicación para guardar. Presiona Actualizar primero.';

  @override
  String error_saving_firestore(Object error) {
    return 'Error al guardar en Firestore: $error';
  }

  @override
  String error_searching_car(Object error) {
    return 'Error buscando el auto: $error';
  }

  @override
  String marker_title_auto_parked(Object id) {
    return 'Auto $id (parked)';
  }

  @override
  String get actualizar_button => 'Actualizar';

  @override
  String get guardar_button => 'Guardar';

  @override
  String get mostrar_ubicacion_tooltip => 'Mostrar ubicación';

  @override
  String get exact_alarms_permission_title => 'Permiso para alarmas exactas';

  @override
  String get exact_alarms_permission_content =>
      'Para que los recordatorios se desencadenen a la hora exacta necesitamos que actives \"Programar alarmas exactas\" en la configuración del teléfono. ¿Querés abrir la configuración ahora?';

  @override
  String get no_button => 'No';

  @override
  String get open_button => 'Abrir';

  @override
  String get reminder_new_title => 'Nuevo recordatorio';

  @override
  String get reminder_edit_title => 'Editar recordatorio';

  @override
  String get reminder_field_title_label => 'Título';

  @override
  String get choose_date => 'Elegir fecha';

  @override
  String get choose_time => 'Elegir hora';

  @override
  String get time_must_be_future => 'La hora debe ser futura';

  @override
  String get reminder_done_delete => 'Realizado / Eliminar';

  @override
  String get reminder_update => 'Actualizar';

  @override
  String get reminder_save => 'Guardar';

  @override
  String get reminder_deleted_success => 'Recordatorio eliminado';

  @override
  String get reminder_updated_success => 'Recordatorio actualizado';

  @override
  String get reminder_created_success => 'Recordatorio creado';

  @override
  String generic_error(Object error) {
    return 'Error: $error';
  }

  @override
  String get appbar_reminders_title => 'Mis Recordatorios';

  @override
  String get no_reminders_message =>
      'No tienes recordatorios.\nVe a la sección \'Mis Vehículos\' para añadir uno desde el detalle de tu auto.';

  @override
  String get vehicle_not_found => 'Vehículo no encontrado';

  @override
  String get vehicle_deleted_message =>
      'Vehículo eliminado. Volviendo a la lista...';

  @override
  String error_snapshot(Object error) {
    return 'Error: $error';
  }

  @override
  String get not_available => 'No disponible';

  @override
  String get delete_vehicle_button => 'Eliminar vehículo';

  @override
  String get park_label => 'Estacionar';

  @override
  String get reminders_label => 'Recordatorios';

  @override
  String get section_vehicle_data => 'DATOS DEL VEHÍCULO';

  @override
  String get edit_vehicle_tooltip => 'Editar datos del vehículo';

  @override
  String get insurance_section_title => 'SEGURO';

  @override
  String get view_policy_tooltip => 'Ver tarjeta circulación';

  @override
  String get no_file_uploaded => 'No hay un archivo cargado.';

  @override
  String get edit_insurance_tooltip => 'Editar datos seguro';

  @override
  String get add_insurance_message => 'No hay un seguro asociado.';

  @override
  String get add_insurance_button => 'Agregar Seguro';

  @override
  String get expenses_section_title => 'GASTOS RECIENTES';

  @override
  String get add_expense_tooltip => 'Añadir gasto';

  @override
  String get view_expenses_tooltip => 'Ver gastos del vehículo';

  @override
  String get no_expenses_registered => 'Ningún gasto registrado';

  @override
  String get add_expense_button => 'Agregar Gasto';

  @override
  String get generic_delete_success => 'Vehículo creado con éxito.';

  @override
  String generic_delete_error(Object error) {
    return 'Error al crear: $error';
  }

  @override
  String get vehicle_edit_title => 'Editar Vehículo';

  @override
  String get vehicle_add_title => 'Añadir Vehículo';

  @override
  String get last_update_label => 'Última actualización';

  @override
  String get brand_label => 'Marca';

  @override
  String get model_label => 'Modelo';

  @override
  String get year_label => 'Año';

  @override
  String get license_plate_label => 'Patente';

  @override
  String get engine_label => 'Motor';

  @override
  String get transmission_label => 'Transmisión';

  @override
  String get brand_required => 'Por favor, ingresa la marca';

  @override
  String get model_required => 'Por favor, ingresa el modelo';

  @override
  String get year_required => 'Por favor, ingresa el año';

  @override
  String get year_invalid => 'Ingresa un año válido';

  @override
  String get license_plate_required => 'Por favor, ingresa la patente';

  @override
  String get engine_required => 'Por favor, ingresa el motor';

  @override
  String get transmission_required => 'Por favor, ingresa la transmisión';

  @override
  String get gallery_option => 'Galería / Explorador de archivos';

  @override
  String get camera_option => 'Cámara';

  @override
  String get no_image_selected => 'Ninguna imagen seleccionada.';

  @override
  String get image_load_error => 'Error al cargar';

  @override
  String get image_picker_gallery_title => 'Galería / Explorador de archivos';

  @override
  String get image_picker_camera_title => 'Cámara';

  @override
  String get camera_button_tooltip => 'Abrir selector de imagen';

  @override
  String get save_changes_button => 'Guardar cambios';

  @override
  String get add_vehicle_button => 'Añadir vehículo';

  @override
  String get vehicle_saved_success => 'Vehículo guardado con éxito.';

  @override
  String get vehicle_created_success => 'Vehículo creado con éxito.';

  @override
  String error_creating(Object error) {
    return 'Error al crear: $error';
  }
}
