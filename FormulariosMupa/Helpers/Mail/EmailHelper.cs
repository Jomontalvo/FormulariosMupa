namespace FormulariosMupa.Helpers.Mail
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using System.Web.Configuration;
    using boDespacho;
    using SIG;
    using sigSQL;
    using MimeKit;
    using MailKit.Net.Smtp;

    /// <summary>
    /// Calse para el envío de e-mails
    /// </summary>
    public class EmailHelper
    {
        /// <summary>
        /// Obtiene la configuración del servicio de correo en los parámetros
        /// </summary>
        public class ConfiguracionServicio
        {
            /// <summary>
            /// URL del sistema web de tareas
            /// </summary>
            public readonly string URLSistemaTareas;
            /// <summary>
            /// Parámetros para envío de e-mails para el servicio
            /// </summary>
            public readonly ParametrosEmail Email;
            /// <summary>
            /// Formato de e-mail de notificación usado por el servicio
            /// </summary>
            public readonly string FormatoEmail;
            /// <summary>
            /// Ruta del archivo de imagen que se puede insertar en el e-mail de notificación
            /// </summary>
            public readonly string ArchivoImagenEmail;
            /// <summary>
            /// Cultura
            /// </summary>
            public readonly string Cultura;

            /// <summary>
            /// Constructor de la clase de configuración del servicio
            /// </summary>
            public ConfiguracionServicio(TsigContexto contexto)
            {
                try
                {
                    var globalizationSection = WebConfigurationManager.GetSection("globalization") as GlobalizationSection;
                    Cultura = globalizationSection.Culture;
                    TRLAQuery query = contexto.BaseDatos.Query();
                    query.AgregarSQL("SELECT * FROM parametros WHERE codigo = 'MAIL_CORRESPONDENCIA';"); //MLHIDE
                    var registro = query.AbrirDataReader(CommandBehavior.SingleRow);
                    if ((registro == null) || !registro.HasRows)
                    {
                        throw new DataException("No fue posible obtener los parámetros del servicio de notificaciones e-mail desde la base de datos");
                    }
                    if (registro.Read())
                        try
                        {
                            // Url del sistema de tareas, que se incorporará como un enlace en los emails de notificación
                            URLSistemaTareas = CampoSQL.AsString(registro["valor_texto1"]);
                            // los parámetros para el envío de email se obtienen a partir de la interpretación del campo "valor_documento2"
                            Email = new ParametrosEmail(CampoSQL.AsString(registro["valor_documento2"]), contexto);
                            // Formato del e-mail
                            FormatoEmail = CampoSQL.AsString(registro["valor_documento1"]);
                            if (registro.IsDBNull("valor_blob1"))
                                ArchivoImagenEmail = string.Empty;
                            else
                                ArchivoImagenEmail = contexto.Cache.Raiz.Guardar(registro.GetUniBlob("valor_blob1"), "jpeg");
                        }
                        catch (Exception ex) { throw new DataException(ex.Message); }
                        finally
                        {
                            registro.Close();
                            query.CerrarConexion();
                        }
                }
                catch (Exception e)
                {
                    TsigNucleo.EscribirLog($"No fue posible inicializar el servicio de notificación vía e-mail. Mensaje de error:{e.Message}");
                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        public struct EmailModel
        {
            /// <summary>
            /// Dirección del originador del e-mail
            /// </summary>
            public string From { get; set; }
            /// <summary>
            /// Nombre o Nick del originador del e-mail
            /// </summary>
            public string NameSender { get; set; }
            /// <summary>
            /// Lista de destinantarios del e-mail 
            /// </summary>
            public string To { get; set; }
            /// <summary>
            /// Nombre del destinatario del e-mail
            /// </summary>
            public string NameRecipient { get; set; }
            /// <summary>
            /// Asunto dell e-mail
            /// </summary>
            public string Subject { get; set; }
            /// <summary>
            /// Contenido del e-mail
            /// </summary>
            public string Content { get; set; }
        }

        /// <summary>
        /// Clase pública para obtener los parámetros de envío de e-mail (Despachos/Tareas)
        /// </summary>
        public class ParametrosEmail
        {
            /// <summary>
            /// Servidor de salida de correo SMTP (Ej.: smtp.gmail.com)
            /// </summary>
            public readonly string ServidorSMTP;
            /// <summary>
            /// Puerto por el cual se autoriza el protocolo SMTP (Ej.: 587)
            /// </summary>
            public readonly int Puerto;
            /// <summary>
            /// Dirección de correo electrónico desde la cuál se envía el correo
            /// </summary>
            public readonly string DireccionEmail;
            /// <summary>
            /// Nombre del remitente (friendly name)
            /// </summary>
            public readonly string Remitente;
            /// <summary>
            /// Nombre de usuario de inicio de sesión para la cuenta
            /// </summary>
            public readonly string Username;
            /// <summary>
            /// Contraseña de inicio de sesión para la cuenta
            /// </summary>
            public readonly string Password;
            /// <summary>
            /// Indicador de uso de Secure Socket Layer SSL
            /// </summary>
            public readonly bool UsarSSL;
            /// <summary>
            /// Asunto del Correo Electrónico (si se desea usar el asunto por defecto
            /// </summary>
            public readonly string AsuntoEmail;

            /// <summary>
            /// Constructor de la clase Parámetros e-mail
            /// </summary>
            /// <param name="listaValores">String con la lista de valores de parámetros que se obtienen de la Base de Datos</param>
            /// <param name="contexto">Contexto activo SIGOB</param>
            public ParametrosEmail(string listaValores, TsigContexto contexto)
            {
                // Paso 1: se obtiene una lista de líneas en el formato parametro=valor, que se almacenará en una tabla hash
                var lista = listaValores.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries); //MLHIDE
                var hash = new Dictionary<string, string>();
                int posicion;

                // Paso 2: se recorre la lista de líneas agregando a la tabla hash cada parámetro con su valor respectivo
                foreach (string linea in lista)
                {
                    posicion = linea.IndexOf('=');

                    if (posicion != 0)
                        hash.Add(linea.Substring(0, posicion), linea.Substring(posicion + 1));
                }

                // Paso 3: se obtienen los parámetros
                ServidorSMTP = hash["SMTP_SERVIDOR"];
                if (int.TryParse(hash["SMTP_PUERTO"], out int numeroPuerto))
                    Puerto = numeroPuerto;
                else
                    Puerto = 25; // número predeterminado puerto SMTP
                DireccionEmail = hash["MAIL_REMITENTE"];
                Remitente = hash["NOMBRE_REMITENTE"];
                Username = hash["SMTP_USUARIO"];
                Password = contexto.Nucleo.Descifrar(hash["SMTP_PASSWORD"]);
                UsarSSL = hash["SMTP_SSL"] == "1";
                AsuntoEmail = hash["ASUNTO_MAIL"];
            }
        }
        
        /// <summary>
        /// Método para envío de los e-mails, usa la información de 
        /// </summary>
        /// <param name="correo">Información del correo electrónico</param>
        /// <param name="contexto">Contexto activo de SIGOB</param>
        public static async Task SendAsync(EmailModel correo, TsigContexto contexto)
        {
            try
            {
                //1. Obtengo la configuración
                var parametros = new ConfiguracionServicio(contexto).Email;

                //2. Creo el menasaje
                var message = new MimeMessage();
                message.From.Add(new MailboxAddress(Encoding.UTF8, parametros.Remitente, parametros.DireccionEmail));
                foreach (string destinatario in correo.To.Split(',').ToList())
                {
                    message.To.Add(new MailboxAddress(Encoding.UTF8, $"Mail: {destinatario}", destinatario));
                }
                message.Subject = correo.Subject;
                // Construcción del Mensaje del correo
                var html = new StringBuilder();
                html.Append("<div><p>");
                html.AppendFormat(correo.Content);
                html.AppendLine("</p></div></br>");
                html.Append($"<span>{correo.NameSender ?? parametros.Remitente}</span>");
                message.Body = new TextPart(MimeKit.Text.TextFormat.Html)
                {
                    Text = html.ToString()
                };

                //Instancia el cliente de correo y envía
                using (var client = new SmtpClient())
                {
                    // For demo-purposes, accept all SSL certificates (in case the server supports STARTTLS)
                    client.ServerCertificateValidationCallback = (s, c, h, e) => true;
                    client.Connect(parametros.ServidorSMTP, parametros.Puerto, parametros.UsarSSL); //Obtener desde configuración de Despachos de SIGOB
                    client.Timeout = 120000;
                    // Establece las credenciales de inicio de sesión de la cuenta.
                    client.Authenticate(parametros.Username, parametros.Password);
                    //Envío asincrónicamente
                    await client.SendAsync(message);
                    client.Disconnect(true);
                }
            }
            catch (Exception ex)
            {
                TsigNucleo.EscribirLog($"No fue posible notificar por e-mail. Mensaje:{ex.Message}");
                return;
            }
        }
    }
}