<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FormulariosMupa._Default" Theme="Sigob" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding-top:10px">
        <asp:Image ID="ImgPanama500" runat="server" ImageUrl="~/App_Themes/Sigob/images/logo_panama500.png" Height="100" ImageAlign="Right" />
        <img alt="Alcaldia de Panamá" src="https://mupa.gob.pa/wp-content/uploads/2018/07/logo_transparencia_black.png">
    </div>
    <div class="jumbotron">
        <h2>Servicios en línea</h2>
        <p class="lead">Portal de servicios de la Alcaldía de Panamá, para inicio de procesos automatizados y en línea. Con el apoyo del Proyecto Regional para la Gobernabilidad PNUD-SIGOB.</p>
        <p><a href="http://www.sigob.org" class="btn btn-primary btn-lg">Más información sobre SIGOB &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Reporte Ciudadano</h2>
            <p>
                Servicio para recepción y atención de reportes de irregularidades en su comunidad que contravengan las normas municipales.
            Para realizar una denuncia ciudadana asegure incluir todos los datos requeridos y en lo posible fotografías que evidencien la situación.
            </p>
            <p>
                <a class="btn btn-default" href="http://sigob.mupa.gob.pa/ReporteCiudadano/Componentes/Formularios/FrmCorrespondenciaExterna.aspx">Nuevo Reporte Ciudadano &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Ventas Ambulantes</h2>
            <p>
                Servicio para registro de solicitudes de venta ambulante o buhoneria en eventos públicos que están aprobados por el Municipio de Panamá.
                Los solicitantes deberán presentar en formato digitalizado todos los requisitos necesarios para la aprobación.
            </p>
            <p>
                <a class="btn btn-default" href="Components/LegalServices/PeddlingAuthorization.aspx">Solicitar permiso &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Consulta de trámites</h2>
            <p>
                Usted puede acceder desde aquí a la consulta del estado de sus trámites y respuesta que la Alcaldía a proporcionado a estos.
                Para ello debo contar con el código del trámite y la constraseña que el Municipio le proporcionó al momento del registro.
            </p>
            <p>
                <a class="btn btn-default" href="http://sigob.mupa.gob.pa/consultaexterna">Nueva consulta &raquo;</a>
            </p>
        </div>
    </div>

</asp:Content>
