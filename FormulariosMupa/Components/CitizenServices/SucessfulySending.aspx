<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SucessfulySending.aspx.cs" Inherits="FormulariosMupa.Components.CitizenServices.SucessfulySending" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Notificación de envío exitoso!</title>
</head>
<body>
    <form id="formSucessfulySending" runat="server">
        <telerik:LayoutColumn runat="server" Span="12" SpanMd="12" SpanSm="12" SpanXs="12">
            <asp:Image runat="server" ID="Image1" ImageUrl="~/images/icons/LogoPC.png" />
            <h1>
                <asp:Label runat="server" ID="nombre_formulario" Text="Reporte Ciudadano" />
            </h1>
            <asp:Image runat="server" ID="Image2" ImageUrl="~/images/icons/TextoPC2.png" />
            <div style="text-align: center;">
                <asp:Button
                    ID="Button1"
                    runat="server"
                    Text="Voler"
                    Font-Size="20px"
                    Height="65px"
                    Width="300px"
                    ToolTip="Presione aqui para salir"
                    PostBackUrl="http://atencion.mupa.gob.pa/" />
            </div>
        </telerik:LayoutColumn>
    </form>
</body>
</html>
