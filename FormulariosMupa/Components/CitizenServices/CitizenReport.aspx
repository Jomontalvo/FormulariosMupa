<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CitizenReport.aspx.cs" Inherits="FormulariosMupa.Components.CitizenServices.CitizenReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>.: Alcaldía de Panamá :: Reporte Ciudadano :.</title>
    <%--<link rel="stylesheet" type="text/css" href="styles.css" />--%>
</head>
<body>
    <form id="formCitizenReport" runat="server">
        <telerik:RadScriptManager ID="RadScriptManagerReport" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js"></asp:ScriptReference>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js"></asp:ScriptReference>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js"></asp:ScriptReference>
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadFormDecorator RenderMode="Lightweight" runat="server" DecoratedControls="Label,Textbox" Skin="Silk" />
        <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
            <Rows>
                <telerik:LayoutRow>
                    <Columns>
                        <telerik:LayoutColumn Span="12" SpanMd="12" SpanSm="12" SpanXs="12">
                            <asp:Image runat="server" ID="Imglogo" ImageUrl="~/images/icons/LogoPC.png" />

                            <h1>
                                <asp:Label runat="server" ID="nombre_formulario" Text="Reporte Ciudadano" /></h1>

                            <div class="usa-alert-info">
                                <div class="usa-alert-body">
                                    <h3 class="usa-alert-heading">
                                        <asp:Label runat="server" ID="titulo_ayuda_formulario" Text="Denuncia Ciudadana" />
                                    </h3>
                                    <p class="usa-alert-info">
                                        <asp:Label runat="server" ID="detalle_tramite" />
                                    </p>
                                </div>
                            </div>
                            <asp:Image runat="server" ID="Image1" ImageUrl="~/images/icons/TextoPC.png" />

                            <div runat="server" id="DivErroresValidacion" visible="false" class="usa-alert usa-alert-error">
                                <div style="padding-left: 80px;">
                                    <asp:ValidationSummary
                                        runat="server"
                                        DisplayMode="BulletList"
                                        ID="ValidationSummary1"
                                        ShowSummary="True"
                                        ShowMessageBox="False"
                                        Font-Size="12pt"
                                        ValidationGroup="EnviarInfo"
                                        ForeColor="Red"
                                        HeaderText="<h3 class='usa-alert-heading'>Por favor solucione los siguientes errores, antes de enviar la solicitud:</h3>" BackColor="#CCFFCC" />
                                </div>
                            </div>

                        </telerik:LayoutColumn>
                    </Columns>
                </telerik:LayoutRow>
            </Rows>
        </telerik:RadPageLayout>


        <telerik:RadPageLayout runat="server">
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="1" SpanMd="2" SpanSm="12" SpanXs="12">

                        <telerik:RadDockLayout ID="RadDockLayout1" runat="server">
                            <telerik:RadDockZone ID="RadDockZone1" runat="server" Height="1200px" Width="900px">
                                <telerik:RadDock ID="RadDock1" runat="server" Width="990">

                                    <TitlebarTemplate>
                                        <strong>
                                            <asp:Image runat="server" ID="Ico01" ImageUrl="~/images/icons/avatar2.png" />
                                            <strong style="vertical-align: top">
                                                <asp:Label runat="server"
                                                    ID="TituloInformacionGrupoSolicitante"
                                                    Text="Datos del solicitante">
                                                </asp:Label>
                                            </strong>
                                        </strong>

                                    </TitlebarTemplate>
                                    <ContentTemplate>
                                        <asp:Image runat="server" ID="Image5" ImageUrl="~/images/icons/Textodatospersonales.png" />
                                        <telerik:RadLabel
                                            runat="server"
                                            ID="Lbl_tipo_correspondencia"
                                            CssClass="LabelCorrespondencia"
                                            Text="Seleccione el tipo de Correspondencia.">
                                        </telerik:RadLabel>
                                        <telerik:RadComboBox
                                            ID="tipo_correspondencia"
                                            runat="server"
                                            Width="95%">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Carta" />
                                                <telerik:RadComboBoxItem Text="Oficio" />
                                                <telerik:RadComboBoxItem Text="Memo" />
                                                <telerik:RadComboBoxItem Text="Nota" />
                                                <telerik:RadComboBoxItem Text="Invitación" />
                                                <telerik:RadComboBoxItem Text="Informe de inspección" />
                                                <telerik:RadComboBoxItem Text="Solicitud de donación" />
                                                <telerik:RadComboBoxItem Text="Solicitud" />
                                                <telerik:RadComboBoxItem Text="Quejas Construcciones" />
                                                <telerik:RadComboBoxItem Text="Quejas Laborales" />
                                                <telerik:RadComboBoxItem Text="Quejas Tributarias" />
                                                <telerik:RadComboBoxItem Text="Quejas Contrataciones" />
                                                <telerik:RadComboBoxItem Text="Quejas Legales" />
                                                <telerik:RadComboBoxItem Text="Quejas Ambientales" />
                                                <telerik:RadComboBoxItem Text="Lanzamientos" />
                                                <telerik:RadComboBoxItem Text="Permisos ciudadanos" />
                                                <telerik:RadComboBoxItem Text="Aprobación Consejo Municipal" />
                                                <telerik:RadComboBoxItem Text="Traslados" />
                                                <telerik:RadComboBoxItem Text="Gestiones de cobro" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <br />
                                        <telerik:RadLabel
                                            runat="server"
                                            ID="Lbl_datos_personales"
                                            CssClass="LabelCorrespondencia"
                                            Text="Datos Personales.">
                                        </telerik:RadLabel>
                                        <br />
                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_documento_identidad"
                                            Width="30%"
                                            EmptyMessage="Cédula.."
                                            ToolTip="Cédula">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator11"
                                            runat="server"
                                            ValidationGroup="EnviarInfo"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_documento_identidad"
                                            Text="*"
                                            ErrorMessage="Ingrese el número de cédula."
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_sexo"
                                            runat="server"
                                            EmptyMessage="Sexo">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Masculino" Value="1" />
                                                <telerik:RadComboBoxItem Text="Femenino" Value="2" />
                                            </Items>
                                        </telerik:RadComboBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator10"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_sexo"
                                            Text="*"
                                            ErrorMessage="Ingrese un Género."
                                            ForeColor="Red"
                                            ValidationGroup="EnviarInfo">

                                        </asp:RequiredFieldValidator>

                                        <telerik:RadTextBox ID="datos_solicitante_nombres"
                                            runat="server"
                                            Width="95%"
                                            ToolTip="Nombres"
                                            EmptyMessage="Nombres">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator4"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_nombres"
                                            Text="*"
                                            ErrorMessage="Ingrese los Nombres."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadTextBox
                                            ID="datos_solicitante_apellidos"
                                            runat="server"
                                            Width="95%"
                                            ToolTip="Apellidos"
                                            EmptyMessage="Apellidos">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator1"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_apellidos"
                                            Text="*"
                                            ErrorMessage="Ingrese los Apellidos."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadTextBox
                                            ID="datos_solicitante_telefono_celular"
                                            runat="server"
                                            Width="30%"
                                            ToolTip="Teléfono Celular"
                                            EmptyMessage="Teléfono Celular">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator2"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_telefono_celular"
                                            Text="*"
                                            ValidationGroup="EnviarInfo"
                                            ErrorMessage="Ingrese un número celular."
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadTextBox
                                            ID="datos_solicitante_telefono_contacto"
                                            runat="server"
                                            Width="30%"
                                            ToolTip="Teléfono Contacto"
                                            EmptyMessage="Teléfono Contacto">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <telerik:RadTextBox ID="datos_solicitante_correo_electronico"
                                            runat="server"
                                            Width="34%"
                                            ToolTip="Email"
                                            EmptyMessage="Email">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator5"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_correo_electronico"
                                            Text="*"
                                            ErrorMessage="Ingrese un Correo electrónico."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <asp:RegularExpressionValidator
                                            ID="RegularExpressionValidator1"
                                            runat="server"
                                            Display="Dynamic"
                                            ErrorMessage="Introduzca un email válido Ej.: abcdef@ghijk.com."
                                            ValidationExpression="^[\w\.\-]+@[a-zA-Z0-9\-]+(\.[a-zA-Z0-9\-]{1,})*(\.[a-zA-Z]{2,3}){1,2}$"
                                            ControlToValidate="datos_solicitante_correo_electronico"
                                            Text="*"
                                            ForeColor="Red"
                                            ValidationGroup="EnviarInfo">
                                        </asp:RegularExpressionValidator>

                                        <asp:RequiredFieldValidator
                                            ID="Requiredfieldvalidator12"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_correo_electronico"
                                            ErrorMessage="Introduzca un email"
                                            Text="*"
                                            ForeColor="Red"
                                            ValidationGroup="EnviarInfo">
                                        </asp:RequiredFieldValidator>

                                    </ContentTemplate>
                                </telerik:RadDock>
                                <telerik:RadDock ID="RadDock2" runat="server" Width="800px">
                                    <TitlebarTemplate>
                                        <strong>
                                            <asp:Image runat="server" ID="Image2" ImageUrl="~/images/icons/placeholder.png" />
                                            <strong style="vertical-align: top">
                                                <asp:Label runat="server"
                                                    ID="Label1"
                                                    Text="Dirección del Reporte">
                                                </asp:Label>
                                            </strong>
                                        </strong>
                                    </TitlebarTemplate>
                                    <ContentTemplate>
                                        <asp:Image runat="server" ID="Image6" ImageUrl="~/images/icons/Textodireccion.png" />
                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_avenida"
                                            Width="30%"
                                            ToolTip="Avenida"
                                            EmptyMessage="Avenida">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator6"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_avenida"
                                            Text="*"
                                            ErrorMessage="Ingrese Nombre de Avenida."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_calle"
                                            Width="30%"
                                            ToolTip="Calle"
                                            EmptyMessage="Calle">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator7"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_calle"
                                            Text="*"
                                            ErrorMessage="Ingrese Nombre de la Calle."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_corregimiento_corregimiento"
                                            runat="server"
                                            Width="35%"
                                            ToolTip="Corregimiento"
                                            Label="Corregimiento :"
                                            ValidationGroup="EnviarInfo"
                                            EmptyMessage="Seleccione..">
                                        </telerik:RadComboBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator8"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_corregimiento_corregimiento"
                                            Text="*"
                                            ErrorMessage="Ingrese un Corregimiento."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>
                                        <br />
                                        <telerik:RadLabel
                                            runat="server"
                                            ID="RadLabel1"
                                            CssClass="LabelCorrespondencia"
                                            Text="Dirección">
                                        </telerik:RadLabel>
                                        <br />
                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_direccion"
                                            Width="96%"
                                            ToolTip="Dirección"
                                            EmptyMessage="Dirección">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator9"
                                            runat="server"
                                            Display="Dynamic"
                                            ControlToValidate="datos_solicitante_direccion"
                                            Text="*"
                                            ErrorMessage="Ingrese una Dirección."
                                            ValidationGroup="EnviarInfo"
                                            ForeColor="Red">
                                        </asp:RequiredFieldValidator>

                                        <telerik:RadLabel
                                            runat="server"
                                            ID="RadLabel2"
                                            CssClass="LabelCorrespondencia"
                                            Text="Nombre del Edificio o Casa /Número y Tipo edificación">
                                        </telerik:RadLabel>
                                        <br />

                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_nombr_edificiocasa"
                                            Width="30%"
                                            ToolTip="Nombre del Edificio o Casa /Número"
                                            EmptyMessage="Nombre del Edificio o Casa /Número ">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_tipo_edificacion"
                                            runat="server"
                                            Width="30%">
                                            <Items>
                                                <telerik:RadComboBoxItem Text="Casa" />
                                                <telerik:RadComboBoxItem Text="Edificio" />
                                                <telerik:RadComboBoxItem Text="Ninguna de las Anteriores" />
                                            </Items>
                                        </telerik:RadComboBox>
                                        <br />
                                        <telerik:RadLabel
                                            runat="server"
                                            ID="RadLabel3"
                                            CssClass="LabelCorrespondencia"
                                            Text="Datos Adicionales">
                                        </telerik:RadLabel>
                                        <br />

                                        <telerik:RadTextBox RenderMode="Lightweight"
                                            runat="server"
                                            ID="datos_solicitante_datos_adicionales"
                                            Width="95%"
                                            ToolTip="Datos Adicionales"
                                            EmptyMessage="Datos Adicionales" Rows="5">
                                            <EmptyMessageStyle ForeColor="LightGray" />
                                        </telerik:RadTextBox>

                                    </ContentTemplate>
                                </telerik:RadDock>

                                <telerik:RadDock ID="RadDock3" runat="server" Width="800px">

                                    <TitlebarTemplate>
                                        <strong>
                                            <asp:Image runat="server" ID="Image3" ImageUrl="~/images/icons/copy.png" />
                                            <strong style="vertical-align: top">
                                                <asp:Label runat="server"
                                                    ID="Label2"
                                                    Text="Datos del Reporte">
                                                </asp:Label>
                                            </strong>
                                        </strong>
                                    </TitlebarTemplate>

                                    <ContentTemplate>
                                        <asp:Image runat="server" ID="Image7" ImageUrl="~/images/icons/Textodetalle.png" />

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_mobiliario_urbano"
                                            runat="server"
                                            Width="30%"
                                            EmptyMessage="Mobiliario Urbano :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_tipo_reporte"
                                            runat="server"
                                            Width="30%"
                                            EmptyMessage="Tipo de Reporte :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_espacios_verdes"
                                            runat="server"
                                            Width="34%"
                                            EmptyMessage="Espacios Verdes :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_servicio_ciudadano"
                                            runat="server"
                                            Width="30%"
                                            EmptyMessage="Servicio al Ciudadano :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_obras_construcciones"
                                            runat="server"
                                            Width="30%"
                                            EmptyMessage="Obras y Construcciones :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_basura_cero"
                                            runat="server"
                                            Width="34%"
                                            EmptyMessage="Basura Cero :">
                                        </telerik:RadComboBox>

                                        <telerik:RadComboBox
                                            ID="datos_solicitante_social"
                                            runat="server"
                                            Width="30%"
                                            EmptyMessage="Social :">
                                        </telerik:RadComboBox>

                                        <div class="CampoTexto">
                                            <telerik:RadLabel
                                                runat="server"
                                                AssociatedControlID="resumen_solicitud"
                                                ID="lbl_resumen_solicitud"
                                                CssClass="LabelCorrespondencia"
                                                Text="Detalle los puntos fundamentales de su solicitud.">
                                            </telerik:RadLabel>

                                            <asp:RequiredFieldValidator
                                                ID="valida_resumen_solicitud"
                                                runat="server"
                                                ValidationGroup="EnviarInfo"
                                                Display="Dynamic"
                                                ControlToValidate="resumen_solicitud"
                                                Text="*"
                                                ErrorMessage="Ingrese los detalles específicos de la solicitud."
                                                ForeColor="Red">
                                            </asp:RequiredFieldValidator>

                                            <telerik:RadTextBox
                                                ID="resumen_solicitud"
                                                runat="server"
                                                TextMode="MultiLine"
                                                ToolTip="Datos detalles específicos de la solicitud"
                                                Width="95%">
                                            </telerik:RadTextBox>
                                        </div>
                                    </ContentTemplate>
                                </telerik:RadDock>

                                <telerik:RadDock ID="RadDock4" runat="server" Width="800px">
                                    <TitlebarTemplate>
                                        <strong>
                                            <asp:Image runat="server" ID="Image4" ImageUrl="~/images/icons/folder.png" />
                                            <strong style="vertical-align: top">
                                                <asp:Label runat="server"
                                                    ID="Label3"
                                                    Text="Anexos, Fotos, Archivos">
                                                </asp:Label>
                                            </strong>
                                        </strong>
                                    </TitlebarTemplate>
                                    <ContentTemplate>

                                        <telerik:RadAsyncUpload
                                            ID="RadAsyncUploadDocumentos"
                                            runat="server"
                                            Width="100"
                                            AllowedFileExtensions=".pdf,.jpeg,.jpg,.png,.doc,.docx,.xls,.xlsx"
                                            OnFileUploaded="RadAsyncUploadDocumentos_FileUploaded">
                                            <Localization Select="Incorporar archivo..." />
                                        </telerik:RadAsyncUpload>
                                    </ContentTemplate>
                                </telerik:RadDock>
                            </telerik:RadDockZone>
                        </telerik:RadDockLayout>
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </telerik:RadPageLayout>

        <!-- Boton Enviar -->
        <br />
        <telerik:RadPageLayout runat="server">
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="11" SpanMd="21" SpanSm="50" SpanXs="50">
                        <telerik:RadCaptcha
                            ID="RadCaptcha1"
                            runat="server"
                            ValidationGroup="EnviarInfo"
                            ErrorMessage="Código introducido errado"
                            Display="Static"
                            ForeColor="Red"
                            CaptchaImage-CharSet="ABCDEFGHJKLMNPRSTUVWXYZ123456789"
                            CaptchaTextBoxLabel=" Introduzca el código mostrado en la imagen"
                            CaptchaImage-TextColor="Black">
                        </telerik:RadCaptcha>

                        <div style="text-align: center;">
                            <telerik:RadButton
                                Visible="true"
                                ValidationGroup="EnviarInfo"
                                runat="server"
                                ID="RbtEnviarSolicitud"
                                Text="Enviar solicitud"
                                ButtonType="SkinnedButton"
                                Font-Size="20px"
                                Height="65px"
                                Width="300px"
                                Primary="true"
                                SingleClick="true"
                                SingleClickText="Enviando solicitud..."
                                OnClick="RbtEnviarSolicitud_Click"
                                RenderMode="Lightweight"
                                ToolTip="Presione aqui para enviar el formulario">
                            </telerik:RadButton>
                        </div>
                        <br />
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </telerik:RadPageLayout>

    </form>
</body>
</html>
