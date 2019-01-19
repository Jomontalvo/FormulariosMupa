namespace FormulariosMupa.Services
{
    using System;
    using System.IO;
    using Telerik.Web.UI;
    using Models;
    using SIG;
    
    /// <summary>
    /// Clase de servicios Soap XML
    /// </summary>
    public class SoapServices
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request">Objeto de solicitud externa de correspondencia</param>
        /// <returns></returns>
        public static bool WebServicePresentacionWebCorrespondencia(ExternalCorrespondence request)
        {
            Boolean resultado = false;
            try
            { 
                request.MedioEnvio = 255;   //Código del medio de recepción de la correspondencia web, por si la institución usa más de uno, 
                                            //el mismo debe ser entre 250 y 255 a excepción del 254 que se usa para correspondencias vinculadas. 
                                            //Si queda en NULO, el sistema lo pondrá como 255    
                //Llamada al servicio web
                wsCorrespondencia.wsCorrespondenciaSoapClient wsTransdoc = new wsCorrespondencia.wsCorrespondenciaSoapClient("wsCorrespondenciaSoap");
                int newCodeCorrespondence = wsTransdoc.CrearPresentacionWeb(
                    Asunto: request.Asunto,
                    Numero_Origen: request.NumeroOrigen,
                    Resumen: request.Resumen,
                    Nombres: request.Nombres,
                    Apellidos: request.Apellidos,
                    Pais: request.Pais,
                    Provincia: request.Provincia,
                    Ciudad: request.Ciudad,
                    Calle: request.Calle,
                    Sexo: request.Sexo,
                    Nro_Documento: request.NroDocumento,
                    Fecha_Nacimiento: request.FechaNacimiento.ToString(),
                    Email: request.Email,
                    Codigo_Postal: request.CodigoPostal,
                    Fax: request.Fax,
                    Tipo_Direccion: request.TipoDireccion,
                    Telefono: request.Telefono,
                    Tipo_Presentacion: request.TipoPresentacion,
                    Medio_Respuesta: request.MedioRespuesta,
                    Clasificadores: request.Clasificadores,
                    Medio_Envio: request.MedioEnvio);
                resultado = true;
            }
            catch (Exception ex) { TsigNucleo.EscribirLog(ex); }
            return resultado;
        }

        /// <summary>
        /// Sube los documentos asociados a una nueva solicitud que existan en el control RadAsyncUpload
        /// </summary>
        /// <param name="code">Código de nueva solicitud de correspondencia externa</param>
        /// <param name="RadAsyncUploadDocuments">Objeto RadAsyncUpload de Telerik</param>
        /// <returns></returns>
        public static bool UploadDocuments(int code, RadAsyncUpload radAsyncUploadDocuments)
        {
            bool ok = false;
            string Archivo = String.Empty;
            string targetFolder = radAsyncUploadDocuments.TargetFolder;
            wsCorrespondencia.wsCorrespondenciaSoapClient wsTransdocAnexo = new wsCorrespondencia.wsCorrespondenciaSoapClient("wsCorrespondenciaSoap");
            for (int i = 0; i < radAsyncUploadDocuments.UploadedFiles.Count; i++)
            {
                Archivo = Path.Combine(targetFolder, radAsyncUploadDocuments.UploadedFiles[i].FileName);
                //targetFolder + RadAsyncUploadDocumentos.UploadedFiles[i].FileName;
                if (File.Exists(Archivo))
                {
                    var fi = new FileInfo(Archivo);
                    byte[] blobSigobAnexo = File.ReadAllBytes(fi.FullName);
                    if (wsTransdocAnexo.SubirDocumentoPresentacionWeb(code, fi.Name, blobSigobAnexo))
                    {
                        //Elimino el archivo temporal
                        File.Delete(Archivo);
                        //Establezco la variable de retorno en true
                        ok = true;
                    }
                }
            }
            return ok;
        }

    }
}