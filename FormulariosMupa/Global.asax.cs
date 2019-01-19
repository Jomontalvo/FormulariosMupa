namespace FormulariosMupa
{

    using System;
    using System.Globalization;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.Optimization;
    using System.Web.Routing;
    using boDespacho;
    using SIG;

    /// <summary>
    /// Parámetros Globales para el inicio de la aplicación
    /// </summary>
    public class Global : HttpApplication
    {
        #region Global Constants

        public static readonly TsigNucleo Nucleo = new TsigNucleo(Conexion: "SIGOB", LeerConfiguracionWeb: true); // Núcleo global del sistema
        public static readonly CultureInfo Cultura = new CultureInfo(WebConfigurationManager.AppSettings["cultura"]); // cultura (localización) del sistema, que será usada para formatear fechas en el sistema
        public static readonly string TituloPrincipal = WebConfigurationManager.AppSettings["titulo"]; // etiqueta principal para mostrar en el sistema
        public static readonly string TituloSecundararia = WebConfigurationManager.AppSettings["titulosecundario"]; // etiqueta secundaria para mostrar en el sistema
        public static readonly string Institucion = WebConfigurationManager.AppSettings["institucion"]; // etiqueta secundaria para mostrar en el sistema
        public static readonly string Pais = WebConfigurationManager.AppSettings["pais"]; // etiqueta secundaria para mostrar en el sistema
        #endregion

        #region Start Procedures
        /// <summary>
        /// Asignacion del contexto cuando se inicia la aplicación
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void Application_Start(object sender, EventArgs e)
        {
            //Defino el contexto de la aplicación
            var contexto = new TsigContexto(Nucleo, InstrumentoSIGOB.Correspondencia) { Institucion = TituloSecundararia };
            Application["Contexto"] = contexto;
            // Código que se ejecuta al iniciar la aplicación
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        /// <summary>
        /// Asignación del contexto cuando se inicia la sewsión
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Session_Start(object sender, EventArgs e)
        {
            var contexto = new TsigContexto(Nucleo, InstrumentoSIGOB.Correspondencia) { Institucion = TituloSecundararia };
            Session["Contexto"] = contexto;
        }
        #endregion

        #region Active Session Management
        /// <summary>
        /// Retorna el contexto (TsigContexto) asociado a la sesión dada
        /// </summary>
        /// <returns>Instancia de TsigContexto correspondiente a la sesión dada</returns>
        public static TsigContexto Contexto()
        {
            var sesion = HttpContext.Current.Session;
            if (sesion == null)
                return null;
            else
                return (TsigContexto)sesion["Contexto"];              //MLHIDE
        }

        /// <summary>
        /// Indica si la sesión ha sido iniciada en el sistema
        /// </summary>
        /// <remarks>
        /// Las sesiones se inician en el sistema llamando al método Login de la clase TsigContexto, que se encarga de obtener
        /// la información de perfil del usuario en SIGOB e inicializar todas las variables de entorno del sistema
        /// </remarks>
        /// <returns>true si la sesión está activa</returns>
        public static bool IsSesionActive()
        {
            var sesion = HttpContext.Current.Session;
            bool resultado = false;
            if (sesion != null)
            {
                var contexto = Contexto();
                resultado = ((contexto != null) && (contexto.SesionActiva));
            }
            return resultado;
        }
        #endregion
    }
}