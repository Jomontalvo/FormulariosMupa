<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PeddlingAuthorization.aspx.cs" Inherits="FormulariosMupa.Components.LegalServices.PeddlingAuthorization" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="../Scripts/controles.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Registro de Solicitud de Ventas Ambulantes</title>
    <link href="../App_Themes/sigob/default.css" rel="stylesheet" />
</head>
<body onload="nobackbutton();">
    <form id="formPeddlingAuth" runat="server" autocomplete="off">
        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                function printing() {
                    window.print();
                }
                function OnClientButtonClicking(sender, args) {
                    var command = args.get_command();
                    if (command == "2") {
                        $telerik.$(".rwzFinish").prop('disabled', true);
                        setTimeout(function () {
                            $telerik.$(".rwzFinish").prop('disabled', false);
                        }, 200)
                    }
                }
                function buttonClick(sender, args) {
                    var command = args.get_command();
                    if (command == "2") {
                        //Se insertan los familiares ingresados
                        var grid = $find("<%=ONSOL_familiares_solicitantes.ClientID%>");
                        var tableView = grid.get_masterTableView();
                        var batchManager = grid.get_batchEditingManager();
                        var items = tableView.get_dataItems();
                        var mapValues = [];
                        for (var i = 0; i < items.length; i++) {
                            var valueToPush = new Array();
                            var mapCellApellidos = items[i].get_cell("apellidos");
                            var mapCellNombres = items[i].get_cell("nombres");
                            var mapCellFechaNacimiento = items[i].get_cell("fecha_de_nacimiento");
                            var mapCellRelacion = items[i].get_cell("tipo_relacion_familia");
                            var mapCellPais = items[i].get_cell("pais_residencia");
                            var mapCellCiudad = items[i].get_cell("ciudad_residencia");
                            valueToPush[0] = batchManager.getCellValue(mapCellApellidos);
                            valueToPush[1] = batchManager.getCellValue(mapCellNombres);
                            valueToPush[2] = batchManager.getCellValue(mapCellFechaNacimiento);
                            valueToPush[3] = batchManager.getCellValue(mapCellRelacion);
                            valueToPush[4] = batchManager.getCellValue(mapCellPais);
                            valueToPush[5] = batchManager.getCellValue(mapCellCiudad);
                            mapValues.push(valueToPush);
                        }
                        document.getElementById("<%= hFamiliares.ClientID %>").value = mapValues;
                        //Se insertan los países de tránsito antes de la llegada a Panamá
                        grid = $find("<%=ONSOL_paises_de_transito.ClientID%>");
                        tableView = grid.get_masterTableView();
                        batchManager = grid.get_batchEditingManager();
                        items = tableView.get_dataItems();
                        var travelValues = [];
                        for (var i = 0; i < items.length; i++) {
                            var valueTravelToPush = new Array();
                            var travelCellPais = items[i].get_cell("nombre_pais");
                            var travelCellFechaInicio = items[i].get_cell("fecha_desde");
                            var travelCellFechaFin = items[i].get_cell("fecha_hasta");
                            var travelCellMedioViaje = items[i].get_cell("medio_para_arribo_pais");
                            valueTravelToPush[0] = batchManager.getCellValue(travelCellPais);
                            valueTravelToPush[1] = batchManager.getCellValue(travelCellFechaInicio);
                            valueTravelToPush[2] = batchManager.getCellValue(travelCellFechaFin);
                            valueTravelToPush[3] = batchManager.getCellValue(travelCellMedioViaje);
                            travelValues.push(valueTravelToPush);
                        }
                        document.getElementById("<%= hPaisesViaje.ClientID %>").value = travelValues;
                    }
                };
            </script>
        </telerik:RadScriptBlock>
        <telerik:RadAjaxManager ID="RadAjaxManagerRegistro" runat="server"></telerik:RadAjaxManager>
        <telerik:RadScriptManager ID="RadScriptManagerRegistro" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js"></asp:ScriptReference>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js"></asp:ScriptReference>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js"></asp:ScriptReference>
            </Scripts>
        </telerik:RadScriptManager>
        <div style="background-color: whitesmoke; width: 100%">
            <div style="float: left; padding: 0px 20px 2px 40px">
                <asp:Image runat="server" ID="imglogo" ImageUrl="~/App_Themes/sigob/imagenes/logo_cabecera.png" Width="90px" />
            </div>
            <div>
                <telerik:RadLabel runat="server" ID="LblTituloPrincipal" Text="Formulario de pre-registro en línea" Font-Bold="true" Font-Size="16pt"></telerik:RadLabel>
                <br />
                <telerik:RadLabel runat="server" ID="LblTituloSecundario" Text="ONPAR - Oficina Nacional para la Atención de Refugiados" Font-Bold="true" Font-Size="12pt"></telerik:RadLabel>
            </div>
        </div>
        <hr style="color: darkgray; background-color: darkgray" />
        <div id="wrapper">
            <telerik:RadWizard ID="RadWizardSolicitud" runat="server" Width="99%" RenderMode="Lightweight" ProgressBarPosition="Top"
                OnFinishButtonClick="RadWizardSolicitud_FinishButtonClick" ValidateRequestMode="Enabled"
                OnClientButtonClicked="buttonClick" OnClientButtonClicking="OnClientButtonClicking">
                <Localization Next="Siguiente" Cancel="Cancelar" Finish="Finalizar" Previous="Anterior" />
                <WizardSteps>
                    <telerik:RadWizardStep runat="server" Title="Solicitante" StepType="Start" ImageUrl="~/App_Themes/sigob/imagenes/iconos/persona24.png"
                        ActiveImageUrl="~/App_Themes/sigob/imagenes/iconos/persona24_a.png" ValidationGroup="InfoPersona" CausesValidation="true">
                        <telerik:RadPageLayout runat="server" ID="PageLayoutInfoPersona" CssClass="t-container-fluid" GridType="Fluid"
                            EnableAjaxSkinRendering="False" EnableEmbeddedBaseStylesheet="True" EnableEmbeddedScripts="true" EnableEmbeddedSkins="False"
                            HtmlTag="Div" RegisterWithScriptManager="True" RenderMode="Classic" ShowGrid="False">
                            <Rows>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="true" HiddenSm="true" HiddenXs="true" Span="12" SpanMd="12">
                                            <div class="usa-alert usa-alert-info-small">
                                                <asp:Label ID="info_solicitante" runat="server" Text="<%$Resources:RecursosOnpar, MensajeWizardPersona%>"></asp:Label>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn Span="6" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_apellidos" Text="??" AssociatedControlID="ONSOL_datos_solicitante_ONPER_apellidos"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtApellidosSolicitante" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_apellidos" ErrorMessage="Ingrese los apellidos del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <br />
                                                <telerik:RadTextBox ID="ONSOL_datos_solicitante_ONPER_apellidos" runat="server" Width="100%" EmptyMessage="Apellidos" ValidationGroup="InfoPersona"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="6" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_nombres" Text="??" AssociatedControlID="ONSOL_datos_solicitante_ONPER_nombres"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtNombreSolicitante" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_nombres" ErrorMessage="Ingrese el nombre(s) del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <br />
                                                <telerik:RadTextBox ID="ONSOL_datos_solicitante_ONPER_nombres" runat="server" Width="100%" EmptyMessage="Nombres" ValidationGroup="InfoPersona"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn Span="3" SpanMd="3" SpanSm="12" SpanXs="12">
                                            <asp:HiddenField runat="server" ID="ONSOL_datos_solicitante" Value="-1" EnableViewState="true" />
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_tipo_documento_identidad" Text="??" AssociatedControlID="ONSOL_datos_solicitante_ONPER_tipo_documento_identidad"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmbTipoIdentidad" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_tipo_documento_identidad" ErrorMessage="Ingrese el tipo de documento de identidad del solicitante." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_tipo_documento_identidad" EmptyMessage="Seleccionar tipo" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false"
                                                    Filter="Contains" Width="100%" ValidationGroup="InfoPersona">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="3" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_no_de_pasaporte" Text="??" AssociatedControlID="ONSOL_datos_solicitante_ONPER_no_de_pasaporte"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtNumeroDocIdentidad" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_no_de_pasaporte" ErrorMessage="Ingrese el número de documento de identidad del solicitante." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox runat="server" ID="ONSOL_datos_solicitante_ONPER_no_de_pasaporte" AutoPostBack="false" Width="100%" AutoCompleteType="none" ValidationGroup="InfoPersona"></telerik:RadTextBox>
                                                <telerik:RadNumericTextBox ID="ONSOL_datos_solicitante_ONPER_codigo" runat="server" Type="Number" NumberFormat-DecimalDigits="0" Visible="false"></telerik:RadNumericTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="3" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_sexo" Text="??" AssociatedControlID="ONSOL_datos_solicitante_ONPER_sexo"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmbSexoSolicitante" runat="server" Display="Dynamic" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_sexo" Text="*" ErrorMessage="Identifique el sexo del solicitante (Hombre/Mujer)." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_sexo" EmptyMessage="Seleccionar" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false"
                                                    MaxHeight="280px" Width="100%" Filter="Contains" ValidationGroup="InfoPersona">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="3" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_estado_civil" ID="lbl_ONSOL_datos_solicitante_ONPER_estado_civil" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmbEstadoCivil" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_estado_civil" ErrorMessage="Ingrese el estado civil del solicitante." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_estado_civil" EmptyMessage="Seleccione estado civil" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false"
                                                    MaxHeight="280px" Width="100%" Filter="Contains" ValidationGroup="InfoPersona">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn Span="3" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento" ID="lbl_ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="dtFechaNacimientoSolicitante" runat="server" Display="Dynamic" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento" Text="*" ErrorMessage="Ingrese fecha de nacimiento del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <asp:RangeValidator ID="dtRangoFechaNacimiento" runat="server" ControlToValidate="ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento"
                                                    ErrorMessage="La fecha de nacimiento tiene un error"
                                                    Display="Dynamic" MaximumValue="2018-01-01-00-00-00" MinimumValue="1900-01-01-00-00-00"></asp:RangeValidator>
                                                <telerik:RadDatePicker runat="server" ID="ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento" RenderMode="Lightweight"
                                                    MinDate="01/01/1900" MaxDate="01/01/2900" Width="100%" DateInput-EmptyMessage="dd MMM yyyy" DateInput-ValidationGroup="InfoPersona">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_pais_de_nacimiento" ID="lbl_ONSOL_datos_solicitante_ONPER_pais_de_nacimiento" Text="País de nacimiento"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmbPaisNacimientoSolicitante" runat="server" Display="Dynamic" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_pais_de_nacimiento" Text="*" ErrorMessage="Ingrese el país de nacimiento del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_pais_de_nacimiento" Width="100%" EmptyMessage="Seleccione un país" Culture="es-PA" MarkFirstMatch="true"
                                                    DataTextField="descrip" DataValueField="clave" MaxHeight="280px" Filter="Contains" ValidationGroup="InfoPersona">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_nacionalidad" ID="lbl_ONSOL_datos_solicitante_ONPER_nacionalidad" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmPaisNacionalidad" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_nacionalidad" ErrorMessage="Ingrese el país de nacionalidad del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_nacionalidad" Width="100%" EmptyMessage="Seleccione un país" Culture="es-PA" MarkFirstMatch="true"
                                                    DataTextField="descrip" DataValueField="clave" MaxHeight="280px" Filter="Contains" ValidationGroup="InfoPersona">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_religion" ID="lbl_ONSOL_datos_solicitante_ONPER_religion" Text="??"></telerik:RadLabel>
                                                <telerik:RadTextBox runat="server" ID="ONSOL_datos_solicitante_ONPER_religion" Width="100%" AutoCompleteType="none" ValidationGroup="InfoPersona"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn Span="9" SpanMd="8" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_direccion_en_panama" AssociatedControlID="ONSOL_datos_solicitante_ONPER_direccion_en_panama" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtDireccionActual" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_direccion_en_panama" ErrorMessage="Ingrese la dirección actual de su domicilio." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox runat="server" ID="ONSOL_datos_solicitante_ONPER_direccion_en_panama" EmptyMessage="Dirección de domicilio actual" Width="100%" InputType="Text" ValidationGroup="InfoPersona" />
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="3" SpanMd="4" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_telefono_de_contacto" AssociatedControlID="ONSOL_datos_solicitante_ONPER_telefono_de_contacto" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtTelefono" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_telefono_de_contacto" ErrorMessage="Ingrese la dirección actual del solicitante." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox runat="server" ID="ONSOL_datos_solicitante_ONPER_telefono_de_contacto" EmptyMessage="+(507) 000-0000" Width="100%" InputType="Tel" ValidationGroup="InfoPersona" />
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_datos_solicitante_ONPER_correo_electronico" AssociatedControlID="ONSOL_datos_solicitante_ONPER_correo_electronico" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtCorreoSolicitante" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoPersona" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_correo_electronico" ErrorMessage="Ingrese un correo electrónico de contacto con el solicitante." ForeColor="Red"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="emailSolicitanteValidator" runat="server" Display="Dynamic" ValidationGroup="InfoPersona"
                                                    ErrorMessage="(Dirección de correo no válida)"
                                                    ValidationExpression="^[\w\.\-]+@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]{1,})*(\.[a-zA-Z]{2,3}){1,2}$"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_correo_electronico" EnableClientScript="true" ForeColor="Red">
                                                </asp:RegularExpressionValidator>
                                                <telerik:RadTextBox runat="server" ID="ONSOL_datos_solicitante_ONPER_correo_electronico" EmptyMessage="nombre_correo@dominio" InputType="Email" Width="100%" ValidationGroup="InfoPersona" />
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <br />
                                                <telerik:RadCheckBox runat="server" ID="ONSOL_datos_solicitante_ONPER_codicion_especial" Text="??" AutoPostBack="false"></telerik:RadCheckBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                            </Rows>
                        </telerik:RadPageLayout>
                    </telerik:RadWizardStep>
                    <telerik:RadWizardStep runat="server" Title="Familiares" StepType="Step" ImageUrl="../App_Themes/sigob/imagenes/iconos/family24.png"
                        ActiveImageUrl="~/App_Themes/sigob/imagenes/iconos/family24_a.png" CausesValidation="true" ValidationGroup="InfoFamilia">
                        <telerik:RadPageLayout runat="server" ID="RadPageLayoutFamiliares" CssClass="t-container-fluid" GridType="Fluid"
                            EnableAjaxSkinRendering="False" EnableEmbeddedBaseStylesheet="True" EnableEmbeddedScripts="False" EnableEmbeddedSkins="False"
                            HtmlTag="Div" RegisterWithScriptManager="True" RenderMode="Classic" ShowGrid="False">
                            <Rows>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="true" HiddenSm="true" HiddenXs="true" Span="12" SpanMd="12">
                                            <div class="usa-alert usa-alert-info-small">
                                                <asp:Label ID="info_beneficiarios" runat="server" Text="<%$Resources:RecursosOnpar, MensajeWizardFamilia%>"></asp:Label>
                                            </div>
                                            <br />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenSm="false" HiddenXs="false" Span="12" SpanMd="12" SpanSm="12">
                                            <telerik:RadGrid ID="ONSOL_familiares_solicitantes" runat="server"
                                                OnPreRender="ONSOL_familiares_solicitantes_PreRender"
                                                OnItemDataBound="ONSOL_familiares_solicitantes_ItemDataBound"
                                                OnNeedDataSource="ONSOL_familiares_solicitantes_NeedDataSource"
                                                OnColumnCreated="ONSOL_familiares_solicitantes_ColumnCreated"
                                                AutoGenerateColumns="False" Width="100%" Culture="es-ES"
                                                AutoGenerateDeleteColumn="true">
                                                <ValidationSettings ValidationGroup="InfoFamilia" />
                                                <MasterTableView Width="100%" EditMode="Batch" InsertItemDisplay="Bottom" CommandItemDisplay="Bottom" HorizontalAlign="Left"
                                                    DataKeyNames="codigo, fecha_de_nacimiento,pais_residencia" TableLayout="Fixed"
                                                    NoMasterRecordsText="No se ha registrado ningún familiar.">
                                                    <CommandItemSettings
                                                        AddNewRecordText="Añadir familiar" CancelChangesText="Cancelar" SaveChangesText="Guardar"
                                                        ShowRefreshButton="false" ShowSaveChangesButton="false" />
                                                    <BatchEditingSettings EditType="Row" />
                                                    <ColumnGroups>
                                                        <telerik:GridColumnGroup Name="InformacionPersona" HeaderText="Datos básicos del familiar"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                        <telerik:GridColumnGroup Name="InformacionDomicilio" HeaderText="Datos de ubicación"
                                                            HeaderStyle-HorizontalAlign="Center" />
                                                    </ColumnGroups>
                                                    <Columns>
                                                        <telerik:GridBoundColumn DataField="codigo" DataType="System.Int32" FilterControlAltText="Filtro código"
                                                            HeaderText="ID" SortExpression="codigo" UniqueName="codigo" Visible="false" ColumnGroupName="InformacionPersona">
                                                            <HeaderStyle HorizontalAlign="Center" Width="60px" />
                                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="apellidos" DataType="System.String" FilterControlAltText="Filtro apellidos"
                                                            HeaderText="Apellido(s)" SortExpression="apellidos" UniqueName="apellidos" ColumnGroupName="InformacionPersona">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoFamilia"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Left" Height="60px" />
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridBoundColumn DataField="nombres" DataType="System.String" FilterControlAltText="Filtro nombres"
                                                            HeaderText="Nombre(s)" SortExpression="nombres" UniqueName="nombres" ColumnGroupName="InformacionPersona">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoFamilia"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Left" />
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridDateTimeColumn DataField="fecha_de_nacimiento" DataType="System.DateTime"
                                                            DataFormatString="dd/MMM/yyyy" EditDataFormatString="dd/MMM/yyyy"
                                                            FilterControlAltText="Filtro fecha nacimiento" ColumnGroupName="InformacionPersona"
                                                            HeaderText="Fec. Nacimiento" SortExpression="fecha_de_nacimiento" UniqueName="fecha_de_nacimiento">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoFamilia"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" Width="180px" />
                                                            <ItemStyle HorizontalAlign="Center" Width="180px" />
                                                        </telerik:GridDateTimeColumn>
                                                        <telerik:GridTemplateColumn DataField="tipo_relacion_familia" DataType="System.String" FilterControlAltText="Filtro tipo relación familiar"
                                                            HeaderText="Relación" SortExpression="tipo_relacion_familia" UniqueName="tipo_relacion_familia" ColumnGroupName="InformacionPersona">
                                                            <EditItemTemplate>
                                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONFAM_tipo_relacion_familia" MaxHeight="200px" ValidationGroup="InfoFamilia" Width="90%"
                                                                    EmptyMessage="Seleccionar" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false" Filter="Contains">
                                                                    <Items>
                                                                        <telerik:RadComboBoxItem Value="1" Text="Abuelo" />
                                                                        <telerik:RadComboBoxItem Value="2" Text="Abuela" />
                                                                        <telerik:RadComboBoxItem Value="3" Text="Esposo" />
                                                                        <telerik:RadComboBoxItem Value="4" Text="Esposa" />
                                                                        <telerik:RadComboBoxItem Value="5" Text="Hermano" />
                                                                        <telerik:RadComboBoxItem Value="6" Text="Hermana" />
                                                                        <telerik:RadComboBoxItem Value="7" Text="Hijo" />
                                                                        <telerik:RadComboBoxItem Value="8" Text="Hija" />
                                                                        <telerik:RadComboBoxItem Value="9" Text="Hijastro" />
                                                                        <telerik:RadComboBoxItem Value="10" Text="Hijastra" />
                                                                        <telerik:RadComboBoxItem Value="11" Text="Madre" />
                                                                        <telerik:RadComboBoxItem Value="12" Text="Padre" />
                                                                        <telerik:RadComboBoxItem Value="13" Text="Tío" />
                                                                        <telerik:RadComboBoxItem Value="14" Text="Tía" />
                                                                        <telerik:RadComboBoxItem Value="15" Text="Otro" />
                                                                    </Items>
                                                                </telerik:RadComboBox>
                                                                <asp:RequiredFieldValidator Width="10%" ID="cmbTipoRelacionFamilia" runat="server" Display="Dynamic" ValidationGroup="InfoFamilia" EnableClientScript="true"
                                                                    ControlToValidate="ONSOL_datos_solicitante_ONFAM_tipo_relacion_familia" Text="*" ErrorMessage="Ingrese tipo de relación familiar" ForeColor="Red"></asp:RequiredFieldValidator>
                                                            </EditItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" Width="180px" />
                                                            <ItemStyle HorizontalAlign="Left" Width="180px" />
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridTemplateColumn DataField="pais_residencia" DataType="System.String" FilterControlAltText="Filtro país"
                                                            HeaderText="País" SortExpression="pais_residencia" UniqueName="pais_residencia" ColumnGroupName="InformacionDomicilio">
                                                            <EditItemTemplate>
                                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_pais_residencia" MaxHeight="200px" Width="95%"
                                                                    ValidationGroup="InfoFamilia" EmptyMessage="Seleccione país" Culture="es-PA" MarkFirstMatch="true"
                                                                    EnableLoadOnDemand="false" Filter="Contains">
                                                                </telerik:RadComboBox>
                                                                <asp:RequiredFieldValidator Width="5%" ID="cmbPaisResidencia" runat="server" Display="Dynamic" ValidationGroup="InfoFamilia" EnableClientScript="true"
                                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_pais_residencia" Text="*" ErrorMessage="Ingrese país de residencia" ForeColor="Red"></asp:RequiredFieldValidator>
                                                            </EditItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" Width="260px" />
                                                            <ItemStyle HorizontalAlign="Left" Width="260px" />
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridBoundColumn DataField="ciudad_residencia" DataType="System.String" FilterControlAltText="Filtro ciudad"
                                                            HeaderText="Ciudad" SortExpression="ciudad_residencia" UniqueName="ciudad_residencia" ColumnGroupName="InformacionDomicilio">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoFamilia"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" Width="170px" />
                                                            <ItemStyle HorizontalAlign="Left" Width="170px" />
                                                        </telerik:GridBoundColumn>
                                                    </Columns>
                                                </MasterTableView>
                                                <ClientSettings ReorderColumnsOnClient="false" AllowDragToGroup="false" AllowColumnsReorder="false">
                                                    <Selecting AllowRowSelect="false" />
                                                </ClientSettings>
                                            </telerik:RadGrid>
                                            <asp:HiddenField runat="server" ID="hFamiliares" ClientIDMode="Static" />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                            </Rows>
                        </telerik:RadPageLayout>
                    </telerik:RadWizardStep>
                    <telerik:RadWizardStep runat="server" Title="Procedencia" StepType="Step" ImageUrl="../App_Themes/sigob/imagenes/iconos/maps24.png"
                        ActiveImageUrl="~/App_Themes/sigob/imagenes/iconos/maps24_a.png" ValidationGroup="InfoProcedencia">
                        <telerik:RadPageLayout runat="server" ID="RadPageLayoutProcedencia" CssClass="t-container-fluid" GridType="Fluid"
                            EnableAjaxSkinRendering="False" EnableEmbeddedBaseStylesheet="True" EnableEmbeddedScripts="True" EnableEmbeddedSkins="False"
                            HtmlTag="Div" RegisterWithScriptManager="True" RenderMode="Classic" ShowGrid="False">
                            <Rows>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="true" HiddenSm="true" HiddenXs="true" Span="12" SpanMd="12">
                                            <div class="usa-alert usa-alert-info-small">
                                                <asp:Label ID="lblProcedencia" runat="server" Text="<%$Resources:RecursosOnpar, MensajeWizardProcedencia%>"></asp:Label>
                                            </div>
                                            <br />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="4" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="ComboBox">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_pais_residencia" ID="lbl_ONSOL_datos_solicitante_ONPER_pais_residencia" Text="País de origen"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="cmPaisResidencia" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoProcedencia"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_pais_residencia" ErrorMessage="Ingrese el país de residencia actual del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadComboBox runat="server" ID="ONSOL_datos_solicitante_ONPER_pais_residencia" Width="100%"
                                                    EmptyMessage="Seleccione país" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false" Filter="Contains"
                                                    DataTextField="descrip" DataValueField="clave" MaxHeight="280px" ValidationGroup="InfoProcedencia">
                                                </telerik:RadComboBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="3" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_ciudad_residencia" ID="lbl_ONSOL_datos_solicitante_ONPER_ciudad_residencia" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtCiudadResidencia" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoProcedencia"
                                                    ControlToValidate="ONSOL_datos_solicitante_ONPER_ciudad_residencia" ErrorMessage="Ingrese la ciudad de origen del solicitante" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_datos_solicitante_ONPER_ciudad_residencia" runat="server" Width="100%" ValidationGroup="InfoProcedencia" />
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="3" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_fecha_salida_pais_origen" AssociatedControlID="ONSOL_fecha_salida_pais_origen" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="dtFechaSalida" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoProcedencia"
                                                    ControlToValidate="ONSOL_fecha_salida_pais_origen" ErrorMessage="Ingrese la fecha de salida del país de origen" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadDatePicker ID="ONSOL_fecha_salida_pais_origen" RenderMode="Lightweight" runat="server" Width="100%"
                                                    DateInput-DisplayDateFormat="dd MMMM yyyy" DateInput-ValidationGroup="InfoProcedencia">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="12" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadCheckBox runat="server" ID="ONSOL_datos_solicitante_ONPER_funcionario_gobierno" Text="??" AutoPostBack="false"></telerik:RadCheckBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="12" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_direccion_zona_pais_origen"
                                                    ID="lbl_ONSOL_datos_solicitante_ONPER_direccion_zona_pais_origen" Text="??">
                                                </telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtDireccionPaisOrigen" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoProcedencia"
                                                    ControlToValidate="ONSOL_fecha_salida_pais_origen" ErrorMessage="Ingrese la dirección en el país de origen" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_datos_solicitante_ONPER_direccion_zona_pais_origen" runat="server" TextMode="MultiLine" Width="100%" ValidationGroup="InfoProcedencia"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="12" SpanMd="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" AssociatedControlID="ONSOL_datos_solicitante_ONPER_informacion_adicional"
                                                    ID="lbl_ONSOL_datos_solicitante_ONPER_informacion_adicional" Text="??">
                                                </telerik:RadLabel>
                                                <telerik:RadTextBox ID="ONSOL_datos_solicitante_ONPER_informacion_adicional" runat="server" TextMode="MultiLine" Width="100%"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                            </Rows>
                        </telerik:RadPageLayout>
                    </telerik:RadWizardStep>
                    <telerik:RadWizardStep runat="server" Title="Viaje" ImageUrl="../App_Themes/sigob/imagenes/iconos/travel24.png"
                        ActiveImageUrl="~/App_Themes/sigob/imagenes/iconos/travel24_a.png" ValidationGroup="InfoViaje">
                        <telerik:RadPageLayout runat="server" ID="RadPageLayoutViaje" CssClass="t-container-fluid" GridType="Fluid"
                            EnableAjaxSkinRendering="False" EnableEmbeddedBaseStylesheet="True" EnableEmbeddedScripts="False" EnableEmbeddedSkins="False"
                            HtmlTag="Div" RegisterWithScriptManager="True" RenderMode="Classic" ShowGrid="False">
                            <Rows>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="true" HiddenSm="true" HiddenXs="true" Span="12" SpanMd="12">
                                            <div class="usa-alert usa-alert-info-small">
                                                <asp:Label ID="lbl_info_viaje" runat="server" Text="<%$Resources:RecursosOnpar, MensajeWizardViaje%>"></asp:Label>
                                            </div>
                                            <br />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="3" SpanMd="4" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_fecha_llegada_panama" AssociatedControlID="ONSOL_fecha_llegada_panama" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="dtFechaLlegada" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoViaje"
                                                    ControlToValidate="ONSOL_fecha_llegada_panama" ErrorMessage="Ingrese fecha de llegada al país" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadDatePicker ID="ONSOL_fecha_llegada_panama" RenderMode="Lightweight" runat="server" Width="100%"
                                                    DateInput-DisplayDateFormat="dd MMMM yyyy" MinDate="" DateInput-ValidationGroup="InfoViaje">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="9" SpanMd="8" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_medios_para_salir_pais" AssociatedControlID="ONSOL_medios_para_salir_pais" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtMediosSalirPais" runat="server" Display="Dynamic" Text="*" ValidationGroup="InfoViaje"
                                                    ControlToValidate="ONSOL_medios_para_salir_pais" ErrorMessage="Relate los detalles del viaje " ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_medios_para_salir_pais" runat="server" TextMode="SingleLine" Width="100%" ValidationGroup="InfoViaje"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="12" SpanMd="12" SpanSm="12" SpanXs="12">
                                            <telerik:RadLabel runat="server" ID="lbl_ONSOL_paises_de_transito" AssociatedControlID="ONSOL_paises_de_transito" Text="??"></telerik:RadLabel>
                                            <telerik:RadGrid ID="ONSOL_paises_de_transito" runat="server"
                                                OnPreRender="ONSOL_paises_de_transito_PreRender"
                                                OnColumnCreated="ONSOL_paises_de_transito_ColumnCreated"
                                                OnNeedDataSource="ONSOL_paises_de_transito_NeedDataSource"
                                                AutoGenerateDeleteColumn="true" AllowMultiRowSelection="false" AllowPaging="false"
                                                ShowFooter="false" ShowStatusBar="true" Width="100%">
                                                <ValidationSettings ValidationGroup="InfoViaje" />
                                                <MasterTableView Width="100%" DataKeyNames="codigo,nombre_pais, fecha_desde, fecha_hasta, medio_para_arribo_pais"
                                                    NoMasterRecordsText="No hay viajes previos registrados." InsertItemDisplay="Bottom" CommandItemDisplay="Bottom"
                                                    HorizontalAlign="NotSet" EditMode="Batch" AutoGenerateColumns="False" ValidateRequestMode="Enabled" TableLayout="Fixed">
                                                    <CommandItemSettings
                                                        AddNewRecordText="Añadir viaje" CancelChangesText="Cancelar" SaveChangesText="Guardar"
                                                        ShowRefreshButton="false" ShowSaveChangesButton="false" />
                                                    <BatchEditingSettings EditType="Row" />
                                                    <Columns>
                                                        <telerik:GridBoundColumn DataField="codigo" DataType="System.Int32" FilterControlAltText="Filtro código"
                                                            HeaderText="ID" SortExpression="codigo" UniqueName="codigo" Visible="false">
                                                            <HeaderStyle HorizontalAlign="Center" Width="60px" />
                                                            <ItemStyle HorizontalAlign="Center" Width="60px" />
                                                        </telerik:GridBoundColumn>
                                                        <telerik:GridTemplateColumn DataField="nombre_pais" DataType="System.String" FilterControlAltText="Filtro país"
                                                            HeaderText="País de tránsito" SortExpression="nombre_pais" UniqueName="nombre_pais">
                                                            <EditItemTemplate>
                                                                <telerik:RadComboBox runat="server" ID="ONSOL_paises_de_transito_ONPTR_nombre_pais" MaxHeight="200px" Width="90%"
                                                                    EmptyMessage="Seleccione país" Culture="es-PA" MarkFirstMatch="true" Filter="Contains" ValidationGroup="InfoViaje">
                                                                </telerik:RadComboBox>
                                                                <asp:RequiredFieldValidator Width="10%" ID="cmbPaisTransito" runat="server" Display="Dynamic" ValidationGroup="InfoViaje" EnableClientScript="true"
                                                                    ControlToValidate="ONSOL_paises_de_transito_ONPTR_nombre_pais" Text="*" ErrorMessage="Ingrese país de tránsito" ForeColor="Red"></asp:RequiredFieldValidator>
                                                            </EditItemTemplate>
                                                            <HeaderStyle HorizontalAlign="Center" Width="30%" />
                                                            <ItemStyle HorizontalAlign="Left" Width="30%" />
                                                        </telerik:GridTemplateColumn>
                                                        <telerik:GridDateTimeColumn DataField="fecha_desde" DataType="System.DateTime" FilterControlAltText="Filtro fecha desde"
                                                            DataFormatString="dd/MMM/yyyy" EditDataFormatString="dd/MMM/yyyy"
                                                            HeaderText="Inicio viaje" SortExpression="fecha_desde" UniqueName="fecha_desde">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoViaje"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Left" />
                                                        </telerik:GridDateTimeColumn>
                                                        <telerik:GridDateTimeColumn DataField="fecha_hasta" DataType="System.DateTime" FilterControlAltText="Filtro fecha hasta"
                                                            DataFormatString="dd/MMM/yyyy" EditDataFormatString="dd/MMM/yyyy"
                                                            HeaderText="Fin viaje" SortExpression="fecha_hasta" UniqueName="fecha_hasta">
                                                            <ColumnValidationSettings EnableRequiredFieldValidation="true">
                                                                <RequiredFieldValidator ForeColor="Red" Text="*" Display="Dynamic" ValidationGroup="InfoViaje"></RequiredFieldValidator>
                                                            </ColumnValidationSettings>
                                                            <HeaderStyle HorizontalAlign="Center" />
                                                            <ItemStyle HorizontalAlign="Left" />
                                                        </telerik:GridDateTimeColumn>
                                                        <telerik:GridTemplateColumn DataField="medio_para_arribo_pais" DataType="System.String" FilterControlAltText="Filtro medio transporte"
                                                            HeaderText="Medio de viaje" SortExpression="medio_para_arribo_pais" UniqueName="medio_para_arribo_pais">
                                                            <EditItemTemplate>
                                                                <telerik:RadComboBox runat="server" ID="ONSOL_paises_de_transito_ONPTR_medio_para_arribo_pais" MaxHeight="240px" ValidationGroup="InfoViaje" Width="90%"
                                                                    EmptyMessage="Seleccione medio" Culture="es-PA" MarkFirstMatch="true" EnableLoadOnDemand="false" Filter="Contains">
                                                                    <Items>
                                                                        <telerik:RadComboBoxItem Value="1" Text="Aéreo" />
                                                                        <telerik:RadComboBoxItem Value="2" Text="Marítimo" />
                                                                        <telerik:RadComboBoxItem Value="3" Text="Terrestre (Vehículo)" />
                                                                        <telerik:RadComboBoxItem Value="4" Text="Terrestre (Caminando)" />
                                                                    </Items>
                                                                </telerik:RadComboBox>
                                                                <asp:RequiredFieldValidator Width="10%" ID="cmbTipoMedioViaje" runat="server" Display="Dynamic" ValidationGroup="InfoViaje" EnableClientScript="true"
                                                                    ControlToValidate="ONSOL_paises_de_transito_ONPTR_medio_para_arribo_pais" Text="*" ErrorMessage="Ingrese medio de viaje" ForeColor="Red"></asp:RequiredFieldValidator>
                                                            </EditItemTemplate>
                                                        </telerik:GridTemplateColumn>
                                                    </Columns>
                                                </MasterTableView>
                                                <ClientSettings AllowKeyboardNavigation="true"></ClientSettings>
                                            </telerik:RadGrid>
                                            <asp:HiddenField runat="server" ID="hPaisesViaje" ClientIDMode="Static" />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                            </Rows>
                        </telerik:RadPageLayout>
                    </telerik:RadWizardStep>
                    <telerik:RadWizardStep runat="server" Title="Motivos de solicitud" ImageUrl="../App_Themes/sigob/imagenes/iconos/passport24.png"
                        ActiveImageUrl="~/App_Themes/sigob/imagenes/iconos/passport24_a.png" StepType="Finish" ValidationGroup="InfoMotivos">
                        <telerik:RadPageLayout runat="server" ID="RadPageLayoutMotivos" CssClass="t-container-fluid" GridType="Fluid"
                            EnableAjaxSkinRendering="False" EnableEmbeddedBaseStylesheet="True" EnableEmbeddedScripts="False" EnableEmbeddedSkins="False"
                            HtmlTag="Div" RegisterWithScriptManager="True" RenderMode="Classic" ShowGrid="False">
                            <Rows>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="true" HiddenSm="true" HiddenXs="true" Span="12" SpanMd="12">
                                            <div class="usa-alert usa-alert-info-small">
                                                <asp:Label ID="info_preguntas" runat="server" Text="<%$Resources:RecursosOnpar, MensajeWizardMotivos%>"></asp:Label>
                                            </div>
                                            <br />
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_resumen_tramite" AssociatedControlID="ONSOL_resumen_tramite" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtSustentacionMotivos" runat="server" Display="Dynamic" ValidationGroup="InfoMotivos" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_resumen_tramite" Text="* Campo obligatorio" ErrorMessage="Ingrese motivos de la solicitud" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_resumen_tramite" runat="server" TextMode="MultiLine" Width="100%" Height="120px" ValidationGroup="InfoMotivos"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_agente_persecutor" AssociatedControlID="ONSOL_agente_persecutor" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtAgentePersecutor" runat="server" Display="Dynamic" ValidationGroup="InfoMotivos" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_agente_persecutor" Text="* Campo obligatorio" ErrorMessage="Ingrese detalles del agente persecutor" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_agente_persecutor" runat="server" TextMode="MultiLine" Width="100%" Height="120px" ValidationGroup="InfoMotivos"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                                <telerik:LayoutRow>
                                    <Columns>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_temores_de_retorno" AssociatedControlID="ONSOL_temores_de_retorno" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtTemoresRetorno" runat="server" Display="Dynamic" ValidationGroup="InfoMotivos" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_temores_de_retorno" Text="* Campo obligatorio" ErrorMessage="Ingrese detalles del agente persecutor" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_temores_de_retorno" runat="server" TextMode="MultiLine" Width="100%" Height="120px" ValidationGroup="InfoMotivos"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                        <telerik:LayoutColumn HiddenMd="false" HiddenSm="false" HiddenXs="false" Span="6" SpanMd="6" SpanSm="12" SpanXs="12">
                                            <div class="CampoTexto">
                                                <telerik:RadLabel runat="server" ID="lbl_ONSOL_eleccion_destino" AssociatedControlID="ONSOL_eleccion_destino" Text="??"></telerik:RadLabel>
                                                <asp:RequiredFieldValidator ID="txtEleccionPanama" runat="server" Display="Dynamic" ValidationGroup="InfoMotivos" EnableClientScript="true"
                                                    ControlToValidate="ONSOL_eleccion_destino" Text="* Campo obligatorio" ErrorMessage="Señale porqué escoge a Panamá" ForeColor="Red"></asp:RequiredFieldValidator>
                                                <telerik:RadTextBox ID="ONSOL_eleccion_destino" runat="server" TextMode="MultiLine" Width="100%" Height="120px"></telerik:RadTextBox>
                                            </div>
                                        </telerik:LayoutColumn>
                                    </Columns>
                                </telerik:LayoutRow>
                            </Rows>
                        </telerik:RadPageLayout>
                    </telerik:RadWizardStep>
                    <telerik:RadWizardStep runat="server" Title="Envío" ImageUrl="../App_Themes/sigob/imagenes/iconos/ok24.png" StepType="Complete">
                        <asp:HiddenField ID="hfCodigoRegistroMia" runat="server" EnableViewState="true" />
                        <telerik:RadLabel runat="server" ID="lblMensajeTitulo" Text="Gracias por enviar su solicitud."></telerik:RadLabel><br />
                        <telerik:RadLabel runat="server" ID="lblMensajeFinal" Text="..."></telerik:RadLabel>
                        <hr />
                        <telerik:RadLabel runat="server" ID="lblFechaRegistro" Text="Usted podrá presentarse a las oficinas de Onpar el día " Font-Bold="true"></telerik:RadLabel>
                        <br />
                        <telerik:RadLabel runat="server" ID="lblCopiaMail" Text="Imprimir página de pre-registro en línea."></telerik:RadLabel>
                        <br />
                        <telerik:RadBarcode ID="RCodeQRSolicitud" runat="server" Type="QRCode" Width="120px" Height="120px" OnPreRender="RCodeQRSolicitud_PreRender">
                            <QRCodeSettings DotSize="0" AutoIncreaseVersion="true" />
                        </telerik:RadBarcode>
                        <br />
                        <telerik:RadButton runat="server" ID="RbtImprimir" RenderMode="Lightweight" Text="Imprimir" OnClick="RbtImprimir_Click" Primary="true">
                            <Icon PrimaryIconCssClass="rbPrint"></Icon>
                        </telerik:RadButton>
                        <br />
                        <asp:HyperLink runat="server" ID="hlnkInicio" Text="Página principal de ONPAR" NavigateUrl="http://www.mingob.gob.pa/onpar"></asp:HyperLink>
                    </telerik:RadWizardStep>
                </WizardSteps>
            </telerik:RadWizard>
        </div>
        <footer title="Ministerio de Gobierno de Panamá">
            <hr />
            <telerik:RadLabel runat="server" ID="lblFooter" Text="©Copyrigth 2017 - Ministerio de Gobierno de Panamá. " Font-Bold="true"></telerik:RadLabel>
            <telerik:RadLabel runat="server" ID="lblFooter2" Text="Todos los derechos reservados."></telerik:RadLabel>
        </footer>
    </form>
</body>
</html>
