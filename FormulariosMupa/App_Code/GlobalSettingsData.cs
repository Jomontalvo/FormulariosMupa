namespace FormulariosMupa.App_Code
{
    using System;
    using System.Data;
    using System.Text;
    using boDespacho;
    using Devart.Data.Universal;
    using sigSQL;
    /// <summary>
    /// Clase para obtención de datos de configuración global.
    /// </summary>
    public class GlobalSettingsData
    {
        #region Get Global Parameters
        /// <summary>
        /// Devuelve datos globales de país, provincia, ciudad y lista de despachos  
        /// </summary>
        /// <param name="data">Configuración solicitada</param>
        /// <returns></returns>
        public static DataSet GetGlobalData(TCacheData data)
        {
            TsigContexto contexto = Global.Contexto();
            var resultado = new DataSet();
            var sql = new StringBuilder();
            TRLAQuery consultasql = contexto.BaseDatos.Query();
            if (contexto.Paises.Clave == null) { GetDefaultCountry(contexto); }
            switch (data)
            {
                case TCacheData.Countries:
                    sql.AppendLine(value: " SELECT RTRIM(LTRIM(clave)) As clave, descrip FROM clasif WHERE  clave LIKE '" + contexto.Paises.Clave + "%' "); //MLHIDE
                    sql.AppendLine(value: " AND    nivel = " + contexto.Paises.Nivel + " "); //MLHIDE
                    sql.AppendLine(value: " AND descrip IS NOT NULL AND descrip <> '' ORDER by descrip"); //MLHIDE
                    consultasql.AgregarSQL(sql.ToString());
                    break;
                case TCacheData.Provinces:
                    sql.AppendLine(value: " SELECT RTRIM(LTRIM(clave)) As clave, descrip, padre FROM clasif WHERE  clave LIKE '" + contexto.Provincias.Clave + "%' "); //MLHIDE
                    sql.AppendLine(value: " AND nivel = " + contexto.Provincias.Nivel + " "); //MLHIDE
                    sql.AppendLine(value: " AND descrip IS NOT NULL AND descrip <> '' ORDER BY descrip"); //MLHIDE
                    consultasql.AgregarSQL(sql.ToString());
                    break;
                case TCacheData.Cities:
                    sql.AppendLine(value: " SELECT RTRIM(LTRIM(clave)) As clave, descrip, RTRIM(LTRIM(padre)) As padre FROM   clasif WHERE  clave LIKE '" + contexto.Ciudades.Clave + "%' "); //MLHIDE
                    sql.AppendLine(value: " AND nivel = " + contexto.Ciudades.Nivel + " "); //MLHIDE
                    sql.AppendLine(value: " AND descrip IS NOT NULL AND descrip <> '' ORDER BY descrip"); //MLHIDE
                    consultasql.AgregarSQL(sql.ToString());
                    break;
                case TCacheData.Offices:
                    sql.AppendLine(value: " SELECT vd.codigo_despa, vd.NOMBRE, vd.descarea, vd.cargo, vd.codfun, vd.codarea, vd.estado "); //MLHIDE
                    sql.AppendLine(value: " FROM v_DespachosAdministracion vd ");      //MLHIDE
                    consultasql.AgregarSQL(sql.ToString());
                    break;
            }
            resultado = consultasql.AbrirDataSet();
            return resultado;
        }

        /// <summary>
        /// Obtiene los valores de configuración por defecto para el país (usado en el proceso de instalción.
        /// </summary>
        /// <param name="contexto"></param>
        private static bool GetDefaultCountry(TsigContexto contexto)
        {
            var sql = new StringBuilder();
            TRLAQuery consultasql = contexto.BaseDatos.Query();
            sql.AppendLine(value: "SELECT  campo02 as clave,ultimo_numero as nivel, password_base_datos as clavedefault, password_sistema as valordeafult"); //MLHIDE
            sql.AppendLine(value: " FROM tabla_par WHERE tipo_instru = '3P'");
            consultasql.AgregarSQL(sql.ToString());
            UniDataReader registro = consultasql.AbrirDataReader();
            if ((registro != null) && registro.HasRows)
            {
                try
                {
                    // Se llena la información del objeto con los datos del registro
                    registro.Read();
                    contexto.Paises.Clave = CampoSQL.AsString(registro["clave"]);
                    contexto.Paises.Nivel = CampoSQL.AsByte(registro["nivel"]);
                    contexto.Paises.ValorPredeterminado = CampoSQL.AsString(registro["clavedefault"]);
                    contexto.Paises.NombreValorPredeterminado = CampoSQL.AsString(registro["valordeafult"]);
                }
                finally { registro.Close(); }
                return true;
            }
            else return false;
        } 
        #endregion

        #region Ticket Generation SIGOB Instruments
        /// <summary>
        /// Genera un nuevo ticket para el uso de Reportes Externos
        /// </summary>
        /// <param name="contexto"></param>
        /// <returns></returns>
        public string GenerarTicket(TsigContexto contexto)
        {
            string strGuid = String.Empty;
            var procedimiento = contexto.BaseDatos.StoredProc(procedimiento: TSigCorrespondenceProcedures.RepGenerarTicket.ToString());           //MLHIDE
            procedimiento.AgregarParametro("PARAMETROS", UniDbType.VarChar).Value = GetParamTicket();
            procedimiento.AgregarParametro("PARAMETROS_INSTRUMENTO", UniDbType.VarChar).Value = GetParamInstrumentoTicket();
            procedimiento.AgregarParametro("TICKET", UniDbType.Guid, ParameterDirection.Output);
            if (procedimiento.Ejecutar())
            {
                // Se obtiene el código del registro del nuevo documento
                strGuid = CampoSQL.AsString(procedimiento.Parametro("TICKET").Value); //MLHIDE
            }
            return strGuid;
        }

        private object GetParamInstrumentoTicket()
        {
            var contexto = Global.Contexto();
            StringBuilder texto = new StringBuilder();
            texto.AppendLine(String.Concat("CLAVE_PAIS=", contexto.Despacho.Contexto.Paises.Clave));
            texto.AppendLine(String.Concat("NIVEL_PAIS=", contexto.Despacho.Contexto.Paises.Nivel));
            texto.Append(String.Concat("TITULO_PAIS=", contexto.Despacho.Contexto.Paises.Titulo));
            return texto.ToString();
        }

        private object GetParamTicket()
        {
            StringBuilder texto = new StringBuilder();
            var contexto = Global.Contexto();
            texto.AppendLine(String.Concat("INSTRUMENTO_PADRE=", contexto.Instrumento));
            texto.AppendLine(String.Concat("DESPACHO=", contexto.Despacho.Codigo));
            texto.AppendLine(String.Concat("NOMBRE=", contexto.Despacho.Funcionario.NombreCompleto));
            texto.AppendLine(String.Concat("CODIGO_AREA=", contexto.Despacho.Area.Codigo));
            texto.AppendLine(String.Concat("NOMBRE_AREA=", contexto.Despacho.Area.Descripcion));
            texto.AppendLine(String.Concat("CARGO=", contexto.Despacho.Cargo));
            texto.AppendLine(String.Concat("FECHA_ACTUAL=", DateTime.Today.ToString("dd/MM/yyyy")));
            texto.Append(String.Concat("HORA_ACTUAL=", DateTime.Now.ToString("HH:mm:ss")));
            return texto.ToString();
        }
        #endregion
    }
}