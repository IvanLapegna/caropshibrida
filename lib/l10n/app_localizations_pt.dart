// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language_es => 'Espanhol';

  @override
  String get language_en => 'Inglês';

  @override
  String get language_pt => 'Português';

  @override
  String get select_language => 'Selecionar Idioma';

  @override
  String get language_label => 'Idioma';

  @override
  String get settings_general_section => 'Geral';

  @override
  String get settings_notifications_section => 'Notificações';

  @override
  String get settings_permissions_section => 'Permissões e Sistema';

  @override
  String get settings_info_section => 'Informações';

  @override
  String get settings_receive_notifications => 'Receber notificações';

  @override
  String get settings_camera_permission => 'Acesso à Câmera';

  @override
  String get settings_system_settings => 'Abrir configurações do sistema';

  @override
  String get settings_version => 'Versão';

  @override
  String get iniciarSesion => 'Entrar';

  @override
  String get porFavorVerificaCorreo =>
      'Por favor, verifique seu e-mail antes de entrar.';

  @override
  String get credencialesInvalidas => 'Credenciais inválidas';

  @override
  String get usuarioDeshabilitado => 'Usuário desativado';

  @override
  String get demasiadosIntentos =>
      'Muitas tentativas. Tente novamente mais tarde.';

  @override
  String get errorRed => 'Erro de rede. Verifique sua conexão.';

  @override
  String get errorInesperado => 'Erro inesperado. Tente novamente.';

  @override
  String get debeIngresarCorreo => 'É necessário inserir o e-mail';

  @override
  String get correoInvalido => 'E-mail inválido';

  @override
  String get debeIngresarContrasena => 'É necessário inserir a senha';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get contrasenaLabel => 'Senha';

  @override
  String get entrar => 'Entrar';

  @override
  String get yaTenesCuentaIniciaSesion => 'Já tem uma conta? Entre';

  @override
  String get registrarse => 'Registrar-se';

  @override
  String get registroExitosoTitle => 'Registro bem-sucedido';

  @override
  String get registroExitosoContent =>
      'Enviamos um e-mail de verificação. Por favor, verifique para poder entrar.';

  @override
  String get aceptar => 'Aceitar';

  @override
  String get confirmarContrasenaLabel => 'Confirmar senha';

  @override
  String get crearCuenta => 'Criar conta';

  @override
  String get yaExisteCuenta => 'Já existe uma conta com esse e-mail.';

  @override
  String get emailInvalido => 'E-mail inválido.';

  @override
  String get contrasenaDebil => 'A senha é muito fraca.';

  @override
  String get noSePudoEnviarCorreoVerificacion =>
      'Não foi possível enviar o e-mail de verificação. Tente novamente mais tarde.';

  @override
  String get confirmacionObligatoria => 'Confirmação obrigatória';

  @override
  String get contrasenasNoCoinciden => 'As senhas não coincidem';

  @override
  String get editar => 'Editar';

  @override
  String get eliminar => 'Excluir';

  @override
  String get eliminarGastoTitle => 'Excluir Despesa';

  @override
  String confirmDeleteExpense(Object description) {
    return 'Tem certeza que deseja excluir a despesa \'$description\'?';
  }

  @override
  String get cancelar => 'Cancelar';

  @override
  String get gastoEliminado => 'Despesa excluída';

  @override
  String errorEliminar(Object error) {
    return 'Erro: $error';
  }

  @override
  String get expense_edit_title => 'Editar Despesa';

  @override
  String get expense_add_title => 'Adicionar Despesa';

  @override
  String get expense_description_label => 'Descrição';

  @override
  String get expense_description_hint => 'Ex.: Combustível';

  @override
  String get expense_description_required =>
      'A descrição da despesa é obrigatória';

  @override
  String get expense_amount_label => 'Valor';

  @override
  String get expense_amount_required => 'O valor da despesa é obrigatório';

  @override
  String get expense_date_label => 'Data da despesa';

  @override
  String get expense_date_required => 'A data é obrigatória';

  @override
  String get expense_type_label => 'Tipo de despesa';

  @override
  String get expense_type_required => 'O tipo de despesa é obrigatório';

  @override
  String get expense_save_changes => 'Salvar alterações';

  @override
  String get expense_add => 'Adicionar despesa';

  @override
  String get error_not_logged => 'Erro: Você não está autenticado.';

  @override
  String get expense_saved_success => 'Despesa salva com sucesso.';

  @override
  String error_saving(Object error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get expense_added_success => 'Despesa adicionada com sucesso.';

  @override
  String error_adding(Object error) {
    return 'Erro ao adicionar: $error';
  }

  @override
  String get expense_list_title => 'Minhas Despesas';

  @override
  String get filter_by_date_title => 'Filtrar por Data';

  @override
  String get date_from_label => 'De:';

  @override
  String get date_to_label => 'Até:';

  @override
  String get select_date => 'Selecionar data';

  @override
  String get cancel => 'Cancelar';

  @override
  String get apply => 'Aplicar';

  @override
  String get filter_by_type_title => 'Filtrar por Tipo';

  @override
  String get view_all => 'Ver todos';

  @override
  String get filter_by_vehicle_title => 'Filtrar por Veículo';

  @override
  String get no_vehicles_registered => 'Você não tem veículos cadastrados';

  @override
  String get fechas_label => 'Datas';

  @override
  String get date_start_short => 'Início';

  @override
  String get date_today_label => 'Hoje';

  @override
  String date_range_from(Object start) {
    return 'De $start';
  }

  @override
  String date_range_to(Object end) {
    return 'Até $end';
  }

  @override
  String date_range_between(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get clear_filters_tooltip => 'Limpar filtros';

  @override
  String get vehicle_label_single => 'Veículo';

  @override
  String get vehicle_placeholder => 'Veículo...';

  @override
  String get type_label => 'Tipo';

  @override
  String get no_expenses_message =>
      'Você não tem despesas.\nVá para \'Meus Veículos\' para adicionar uma a partir do detalhe do carro.';

  @override
  String get no_expenses_filtered =>
      'Nenhuma despesa encontrada com esses filtros.';

  @override
  String error_generic(Object error) {
    return 'Erro: $error';
  }

  @override
  String get home_title => 'Meus Veículos';

  @override
  String get no_vehicles_home =>
      'Você não tem veículos.\nToque em (+) para adicionar um.';

  @override
  String get loading => 'Carregando...';

  @override
  String get tooltip_expenses => 'Despesas';

  @override
  String get tooltip_add_vehicle => 'Adicionar veículo';

  @override
  String get tooltip_settings => 'Configurações';

  @override
  String get no_vehicles_centered =>
      'Você não tem veículos.\nToque em (+) para adicionar um.';

  @override
  String get logout_confirmation_hint => 'Sair';

  @override
  String get reminders_button_tooltip => 'Lembretes';

  @override
  String get insurance_edit_title => 'Editar Seguro';

  @override
  String get insurance_add_title => 'Adicionar Seguro';

  @override
  String get insurance_name_label => 'Seguradora';

  @override
  String get insurance_name_required => 'O nome da seguradora é obrigatório';

  @override
  String get policy_number_label => 'Nº da apólice';

  @override
  String get policy_number_required => 'O número da apólice é obrigatório';

  @override
  String get expiration_date_label => 'Data de expiração';

  @override
  String get expiration_date_required => 'A data de expiração é obrigatória';

  @override
  String get coverage_label => 'Tipo de cobertura';

  @override
  String get coverage_required => 'O tipo de cobertura é obrigatório';

  @override
  String get engine_number_label => 'Nº do motor';

  @override
  String get engine_number_required => 'O número do motor é obrigatório';

  @override
  String get chassis_number_label => 'Nº do chassi';

  @override
  String get chassis_number_required => 'O número do chassi é obrigatório';

  @override
  String get policy_holder_label => 'Titular';

  @override
  String get policy_holder_required => 'O nome do titular é obrigatório';

  @override
  String get policy_document_title => 'Comprovante de Apólice Digital';

  @override
  String get pick_file_hint => 'Toque para enviar a apólice (PDF ou foto)';

  @override
  String get current_file_label => 'Arquivo atual:';

  @override
  String get file_picker_edit_icon_semantic => 'Editar arquivo';

  @override
  String get save_changes => 'Salvar alterações';

  @override
  String get add_insurance => 'Adicionar seguro';

  @override
  String get insurance_saved_success => 'Seguro salvo com sucesso.';

  @override
  String get insurance_added_success => 'Seguro adicionado com sucesso.';

  @override
  String get map_title => 'Onde estacionei?';

  @override
  String get no_car_id => 'ID do carro inválido. Mostrando localização atual.';

  @override
  String get location_service_disabled => 'Serviço de localização desativado.';

  @override
  String get location_permission_denied => 'Permissão de localização negada.';

  @override
  String get location_permission_denied_forever =>
      'Permissão de localização negada permanentemente. Habilite nas configurações.';

  @override
  String error_getting_location(Object error) {
    return 'Erro ao obter localização: $error';
  }

  @override
  String get info_selected_location => 'Local selecionado';

  @override
  String get info_parked_here => 'Estacionado aqui';

  @override
  String get no_location_to_save =>
      'Não há localização para salvar. Pressione Atualizar primeiro.';

  @override
  String error_saving_firestore(Object error) {
    return 'Erro ao salvar no Firestore: $error';
  }

  @override
  String error_searching_car(Object error) {
    return 'Erro ao buscar o carro: $error';
  }

  @override
  String marker_title_auto_parked(Object id) {
    return 'Carro $id (estacionado)';
  }

  @override
  String get actualizar_button => 'Atualizar';

  @override
  String get guardar_button => 'Salvar';

  @override
  String get mostrar_ubicacion_tooltip => 'Mostrar localização';

  @override
  String get exact_alarms_permission_title => 'Permissão para alarmes exatos';

  @override
  String get exact_alarms_permission_content =>
      'Para que os lembretes sejam disparados no horário exato, precisamos que você ative \"Programar alarmes exatos\" nas configurações do telefone. Deseja abrir as configurações agora?';

  @override
  String get no_button => 'Não';

  @override
  String get open_button => 'Abrir';

  @override
  String get reminder_new_title => 'Novo lembrete';

  @override
  String get reminder_edit_title => 'Editar lembrete';

  @override
  String get reminder_field_title_label => 'Título';

  @override
  String get choose_date => 'Escolher data';

  @override
  String get choose_time => 'Escolher hora';

  @override
  String get time_must_be_future => 'A hora deve ser futura';

  @override
  String get reminder_done_delete => 'Concluído / Excluir';

  @override
  String get reminder_update => 'Atualizar';

  @override
  String get reminder_save => 'Salvar';

  @override
  String get reminder_deleted_success => 'Lembrete excluído';

  @override
  String get reminder_updated_success => 'Lembrete atualizado';

  @override
  String get reminder_created_success => 'Lembrete criado';

  @override
  String generic_error(Object error) {
    return 'Erro: $error';
  }

  @override
  String get appbar_reminders_title => 'Meus Lembretes';

  @override
  String get no_reminders_message =>
      'Você não tem lembretes.\nVá para \'Meus Veículos\' para adicionar um a partir do detalhe do carro.';

  @override
  String get vehicle_not_found => 'Veículo não encontrado';

  @override
  String get vehicle_deleted_message =>
      'Veículo excluído. Retornando para a lista...';

  @override
  String error_snapshot(Object error) {
    return 'Erro: $error';
  }

  @override
  String get not_available => 'Não disponível';

  @override
  String get delete_vehicle_button => 'Excluir veículo';

  @override
  String get park_label => 'Estacionar';

  @override
  String get reminders_label => 'Lembretes';

  @override
  String get section_vehicle_data => 'DADOS DO VEÍCULO';

  @override
  String get edit_vehicle_tooltip => 'Editar dados do veículo';

  @override
  String get insurance_section_title => 'SEGURO';

  @override
  String get view_policy_tooltip => 'Ver documento da apólice';

  @override
  String get no_file_uploaded => 'Nenhum arquivo enviado.';

  @override
  String get edit_insurance_tooltip => 'Editar dados do seguro';

  @override
  String get add_insurance_message => 'Nenhum seguro associado.';

  @override
  String get add_insurance_button => 'Adicionar seguro';

  @override
  String get expenses_section_title => 'DESPESAS RECENTES';

  @override
  String get add_expense_tooltip => 'Adicionar despesa';

  @override
  String get view_expenses_tooltip => 'Ver despesas do veículo';

  @override
  String get no_expenses_registered => 'Nenhuma despesa registrada';

  @override
  String get add_expense_button => 'Adicionar Despesa';

  @override
  String get generic_delete_success => 'Veículo criado com sucesso.';

  @override
  String generic_delete_error(Object error) {
    return 'Erro ao criar: $error';
  }

  @override
  String get vehicle_edit_title => 'Editar Veículo';

  @override
  String get vehicle_add_title => 'Adicionar Veículo';

  @override
  String get last_update_label => 'última atualização';

  @override
  String get brand_label => 'Marca';

  @override
  String get model_label => 'Modelo';

  @override
  String get year_label => 'Ano';

  @override
  String get license_plate_label => 'Placa';

  @override
  String get engine_label => 'Motor';

  @override
  String get transmission_label => 'Transmissão';

  @override
  String get brand_required => 'Por favor, insira a marca';

  @override
  String get model_required => 'Por favor, insira o modelo';

  @override
  String get year_required => 'Por favor, insira o ano';

  @override
  String get year_invalid => 'Insira um ano válido';

  @override
  String get license_plate_required => 'Por favor, insira a placa';

  @override
  String get engine_required => 'Por favor, insira o motor';

  @override
  String get transmission_required => 'Por favor, insira a transmissão';

  @override
  String get gallery_option => 'Galeria / Explorador de arquivos';

  @override
  String get camera_option => 'Câmera';

  @override
  String get no_image_selected => 'Nenhuma imagem selecionada.';

  @override
  String get image_load_error => 'Erro ao carregar';

  @override
  String get image_picker_gallery_title => 'Galeria / Explorador de arquivos';

  @override
  String get image_picker_camera_title => 'Câmera';

  @override
  String get camera_button_tooltip => 'Abrir seletor de imagem';

  @override
  String get save_changes_button => 'Salvar alterações';

  @override
  String get add_vehicle_button => 'Adicionar veículo';

  @override
  String get vehicle_saved_success => 'Veículo salvo com sucesso.';

  @override
  String get vehicle_created_success => 'Veículo criado com sucesso.';

  @override
  String error_creating(Object error) {
    return 'Erro ao criar: $error';
  }
}
