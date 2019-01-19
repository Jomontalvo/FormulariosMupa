using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FormulariosMupa.Models
{
    /// <summary>
    /// Estructura de una solicitud externa de correspondencia vía web
    /// </summary>
    public class ExternalCorrespondence
    {
        #region Properties
        /// <summary>
        /// Asunto de la correspondencia (título explicativo)
        /// </summary>
        public string Asunto { get; internal set; }
        /// <summary>
        /// Número asignado por el originador de la correspondencia
        /// </summary>
        public string NumeroOrigen { get; internal set; }
        /// <summary>
        /// Texto con el detalle de la correspondencia
        /// </summary>
        public string Resumen { get; internal set; }
        /// <summary>
        /// Nombres del emisor de la correspondencia
        /// </summary>
        public string Nombres { get; internal set; }
        /// <summary>
        /// Apellidos del emisor de la correspondencia
        /// </summary>
        public string Apellidos { get; internal set; }
        /// <summary>
        /// País de la dirección del emisor
        /// </summary>
        public string Pais { get; internal set; }
        /// <summary>
        /// Provincia de la dirección del emisor
        /// </summary>
        public string Provincia { get; internal set; }
        /// <summary>
        /// Ciudad de la dirección del emisor
        /// </summary>
        public string Ciudad { get; internal set; }
        /// <summary>
        /// Corregimiento de la dirección del emisor
        /// </summary>
        public string Corregimiento { get; internal set; }
        /// <summary>
        /// Calle y nro. de la dirección del emisor
        /// </summary>
        public string Calle { get; internal set; }
        /// <summary>
        /// Sexo del emisor. 1: Masculino / 2: Femenino
        /// </summary>
        public short Sexo { get; internal set; }
        /// <summary>
        /// Número del documento de identidad del emisor
        /// </summary>
        public string NroDocumento { get; internal set; }
        /// <summary>
        /// Fecha de nacimiento del emisor
        /// </summary>
        public string FechaNacimiento { get; internal set; }
        /// <summary>
        /// Dirección de correo electrónico del emisor
        /// </summary>
        public string Email { get; internal set; }
        /// <summary>
        /// Código postal de la dirección del emisor
        /// </summary>
        public string CodigoPostal { get; internal set; }
        /// <summary>
        /// Nro. de Fax o Teléfono fijo del emisor
        /// </summary>
        public string Fax { get; internal set; }
        /// <summary>
        /// Indicador del tipo de dirección: Personal:0 | Laboral:1
        /// </summary>
        public short TipoDireccion { get; internal set; }
        /// <summary>
        /// Nro. de teléfono fijo o celular
        /// </summary>
        public string Telefono { get; internal set; }
        /// <summary>
        /// Tipo de solicitud externa que se está registrando
        /// </summary>
        public string TipoPresentacion { get; internal set; }
        /// <summary>
        /// Indica el medio de respuesta por el cuál el ciudadano prefiere recibirla.
        /// </summary>
        public string MedioRespuesta { get; internal set; }
        /// <summary>
        /// Códigos de clasificadores asociados a la presentación web (separados por ,)
        /// </summary>
        public string Clasificadores { get; internal set; }
        /// <summary>
        /// Por defecto podría ser 255 para señalar que es a partir de un formulario web
        /// </summary>
        public short MedioEnvio { get; internal set; }
        #endregion
    }
}