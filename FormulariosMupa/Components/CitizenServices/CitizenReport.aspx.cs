namespace FormulariosMupa.Components.CitizenServices
{
    using System;
    using System.Data;
    using System.Drawing;
    using System.Text;
    using System.Web.UI;
    using Telerik.Web.UI;
    using boDespacho;
    using FormulariosMupa.App_Code;
    using FormulariosMupa.Helpers.Mail;
    using FormulariosMupa.Models;
    using Services;
    using SIG;

    /// <summary>
    /// Code Behind de Formulario de Reporte Ciudadano
    /// </summary>
    public partial class CitizenReport : System.Web.UI.Page
    {
        private static int codCorrespondencia;

        void Page_PreRender(object sender, EventArgs e)
        {
            // Save CodigoNuevaCorrespondencia before the page is rendered.
            ViewState.Add("codigoNuevaCorrespondencia", codCorrespondencia);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Defino la ruta del Upload
                RadAsyncUploadDocumentos.TargetFolder = Global.Nucleo.DirectorioTemporal;
                //Llenado de ComboBox
                Llenar_lista_corregimientos();
                Llenar_lista_mobiliario_urbano();
                Llenar_lista_tipo_reporte();
                Llenar_lista_espacios_verdes();
                Llenar_lista_servicio_ciudadano();
                Llenar_lista_obras_construcciones();
                Llenar_lista_basura_cero();
                Llenar_lista_social();

            }
            //Recupero las variables 
            if (ViewState["codigoNuevaCorrespondencia"] != null)
                codCorrespondencia = (int)ViewState["codigoNuevaCorrespondencia"];
        }

        #region LLenado de Listas y Datos paramétricos
        private void Llenar_lista_corregimientos()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("0201010804", 6);
            datos_solicitante_corregimiento_corregimiento.DataTextField = "descrip";
            datos_solicitante_corregimiento_corregimiento.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_corregimiento_corregimiento.DataSource = tabla;
            datos_solicitante_corregimiento_corregimiento.DataBind();

        }

        private void Llenar_lista_mobiliario_urbano()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010103", 5);
            datos_solicitante_mobiliario_urbano.DataTextField = "descrip";
            datos_solicitante_mobiliario_urbano.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_mobiliario_urbano.DataSource = tabla;
            datos_solicitante_mobiliario_urbano.DataBind();

        }

        private void Llenar_lista_tipo_reporte()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("050101", 4);
            datos_solicitante_tipo_reporte.DataTextField = "descrip";
            datos_solicitante_tipo_reporte.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_tipo_reporte.DataSource = tabla;
            datos_solicitante_tipo_reporte.DataBind();

        }

        private void Llenar_lista_espacios_verdes()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010101", 5);
            datos_solicitante_espacios_verdes.DataTextField = "descrip";
            datos_solicitante_espacios_verdes.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_espacios_verdes.DataSource = tabla;
            datos_solicitante_espacios_verdes.DataBind();

        }

        private void Llenar_lista_servicio_ciudadano()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010102", 5);
            datos_solicitante_servicio_ciudadano.DataTextField = "descrip";
            datos_solicitante_servicio_ciudadano.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_servicio_ciudadano.DataSource = tabla;
            datos_solicitante_servicio_ciudadano.DataBind();

        }

        private void Llenar_lista_obras_construcciones()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010104", 5);
            datos_solicitante_obras_construcciones.DataTextField = "descrip";
            datos_solicitante_obras_construcciones.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_obras_construcciones.DataSource = tabla;
            datos_solicitante_obras_construcciones.DataBind();

        }

        private void Llenar_lista_basura_cero()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010107", 5);
            datos_solicitante_basura_cero.DataTextField = "descrip";
            datos_solicitante_basura_cero.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_basura_cero.DataSource = tabla;
            datos_solicitante_basura_cero.DataBind();

        }

        private void Llenar_lista_social()
        {
            var datos = new GlobalSettingsData();
            DataSet resultado = datos.GetListClassifiers("05010105", 5);
            datos_solicitante_social.DataTextField = "descrip";
            datos_solicitante_social.DataValueField = "clave";
            DataTable tabla = resultado.Tables[0];
            datos_solicitante_social.DataSource = tabla;
            datos_solicitante_social.DataBind();
        }
        #endregion

        #region Commands
        protected void RbtEnviarSolicitud_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) 
                DivErroresValidacion.Visible = true;
            else
                SendRequest();
        }

        /// <summary>
        /// Envío de la solicitud externa vía web
        /// </summary>
        private void  SendRequest()
        {
            var request = new ExternalCorrespondence();
            if (!WebServicePresentacionWebCorrespondencia(ref request))
            {
                detalle_tramite.BackColor = Color.IndianRed;
                detalle_tramite.Text = "Error en el registro y envío de la solicitud. Intente de nuevo más tarde!";
            }
            if (!SubirDocumentos(codCorrespondencia))
            {
                detalle_tramite.BackColor = Color.IndianRed;
                detalle_tramite.Text = "Error en el registro de documentos adjuntos a la solicitud. Inténtelo nuevamente!";

            }
            //Construyo la notificación de recepción exitosa
            {
                try
                {
                    var notificacion = new StringBuilder();
                    notificacion.AppendLine("Su solicitud ha sido enviada exitosamente al Municipio de Panamá.");
                    notificacion.AppendLine("Una vez hayan sido validados sus datos y verificados los contenidos de esta, recibirá un correo de notificación con la información de:");
                    notificacion.AppendLine("- Código de Registro");
                    notificacion.AppendLine("- Contraseña para consulta vía web");
                    notificacion.AppendLine(Environment.NewLine);
                    var correo = new EmailHelper.EmailModel()
                    {
                        Subject = "Recepción de Reporte Ciudadano para validación",
                        To = request.Email,
                        NameRecipient = $"{request.Apellidos}, {request.Nombres}",
                        Content = notificacion.ToString()
                    };
                    TsigContexto contexto = new TsigContexto(Global.Nucleo, InstrumentoSIGOB.Correspondencia);
                    EmailHelper.Send(correo, contexto);
                    Response.Redirect(String.Concat("SucessfulySending.aspx?CODIGO=", codCorrespondencia.ToString()));
                }
                catch (Exception ex) { TsigNucleo.EscribirLog($"No fue posible notificar por e-mail. Mensaje:{ex.Message}"); }
            }

        }

        private bool WebServicePresentacionWebCorrespondencia(ref ExternalCorrespondence request)
        {
            Boolean resultado = false;
            try
            {
                request.Asunto = String.Concat(tipo_correspondencia.Text != ""
                                            ? tipo_correspondencia.Text : "Solicitud vía web",
                                            " de ",
                                            datos_solicitante_apellidos.Text.Trim(),
                                            ", ",
                                            datos_solicitante_nombres.Text.Trim()
                                            ); 
                request.NumeroOrigen = String.Empty;
                request.Resumen = String.Concat(resumen_solicitud.Text,
                                 datos_solicitante_datos_adicionales.Text,
                                 "Tipo de Solicitud : ",
                                 tipo_correspondencia.Text,
                                 "Tipo de Edificación : ",
                                 datos_solicitante_tipo_edificacion.Text,
                                 "Nombre Edicio, casa /número casa : ",
                                 datos_solicitante_nombr_edificiocasa.Text
                                 );
                request.NroDocumento = datos_solicitante_documento_identidad.Text.Trim();
                request.Nombres = datos_solicitante_nombres.Text.Trim();
                request.Apellidos = datos_solicitante_apellidos.Text.Trim();
                request.Sexo = String.IsNullOrEmpty(datos_solicitante_sexo.SelectedValue) ? 
                    Convert.ToInt16(datos_solicitante_sexo.SelectedValue) : 
                    Convert.ToInt16(0);
                request.Pais = "Panamá";
                request.Provincia = "Panamá";
                request.Ciudad = "Panamá";
                request.Corregimiento = datos_solicitante_corregimiento_corregimiento.Text.Trim();
                request.Calle = datos_solicitante_direccion.Text.Trim();

                //datos_solicitante_calle.Text.Trim();                                   // Calle y nro. de la dirección del emisor
                //datos_solicitante_avenida.Text.Trim();                                 // Calle y nro. de la dirección del emisor
                request.FechaNacimiento = String.Empty;
                request.Email = datos_solicitante_correo_electronico.Text;
                request.CodigoPostal = String.Empty;
                request.TipoDireccion = 0;
                request.Fax = datos_solicitante_telefono_contacto.Text;
                request.Telefono = datos_solicitante_telefono_celular.Text;
                request.TipoPresentacion = tipo_correspondencia.Text;
                request.MedioRespuesta = "Correo";
                request.Clasificadores = String.Concat(
                    datos_solicitante_mobiliario_urbano.SelectedIndex >= 0 ? datos_solicitante_mobiliario_urbano.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_tipo_reporte.SelectedIndex > 0 ? datos_solicitante_tipo_reporte.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_espacios_verdes.SelectedIndex > 0 ? datos_solicitante_espacios_verdes.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_servicio_ciudadano.SelectedIndex > 0 ? datos_solicitante_servicio_ciudadano.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_obras_construcciones.SelectedIndex > 0 ? datos_solicitante_obras_construcciones.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_basura_cero.SelectedIndex > 0 ? datos_solicitante_basura_cero.SelectedValue.Trim() : String.Empty,",",
                    datos_solicitante_social.SelectedIndex > 0 ? datos_solicitante_social.SelectedValue.Trim() : String.Empty);
                //Asigno el resultado de la llamada Soap
                resultado = SoapServices.WebServicePresentacionWebCorrespondencia(request);
            }
            catch (Exception e)
            {
                TsigNucleo.EscribirLog(e);
                Response.Write(e.Message);
            }
            return resultado;
        }

        /// <summary>
        /// Upload de documentos relacionados al formulario
        /// </summary>
        /// <param name="codigo"></param>
        /// <returns></returns>
        private bool SubirDocumentos(int codigo)
        {
            foreach (RadAsyncUpload uploadBox in RadDock4.ContentContainer.Controls)
            {
                if (!SoapServices.UploadDocuments(codigo, this.RadAsyncUploadDocumentos)) return false;
            }
            return true;
        }

        /// <summary>
        /// Confirmación de subida de los documentos anexos
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadAsyncUploadDocumentos_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            string targetFolder = RadAsyncUploadDocumentos.TargetFolder;
            string fileName = e.File.GetName();
            Console.Write("@" + "targetFolder :" + targetFolder + " filename :" + fileName);
        }
        #endregion
    }
}