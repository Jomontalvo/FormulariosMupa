namespace FormulariosMupa.Components.LegalServices
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Diagnostics;
    using System.Drawing;
    using System.IO;
    using System.Net;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Web.Configuration;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using boDespacho;
    using Comun;
    using Devart.Data.Universal;
    using SIG;
    using sigSQL;
    using Telerik.Web.UI;
    using Telerik.Web.UI.Barcode;

    public partial class PeddlingAuthorization : System.Web.UI.Page
    {
        private static int id = 0;
        private static int vistaMiaAsociado;
        private static string miaAsociado;
        private static string despachoCoordinador;
        private static TsigDirectorio Directorio;
        private string sSource = "SIGOB";
        private string sEvent;

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Save PageArrayList before the page is rendered.
            ViewState.Add("vistaMiaAsociado", vistaMiaAsociado);
            ViewState.Add("miaAsociado", miaAsociado);
            ViewState.Add("despachoCoordinador", despachoCoordinador);
            //Límites para la fecha de Ingreso a Panamá
            ONSOL_fecha_llegada_panama.MaxDate = DateTime.Today;
            ONSOL_fecha_llegada_panama.MinDate = DateTime.Today.AddMonths(-6);
        }

        /// <summary>
        /// Inicio de carga de la página
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            string ip = String.Empty;
            if (!EsRequestIpValida(ref ip))
            {
                LblTituloPrincipal.ForeColor = Color.IndianRed;
                LblTituloPrincipal.Text = String.Concat("No está permitido utilizar el formulario", ip);
                RadWizardSolicitud.Visible = false;
                Response.Redirect("http://www.mingob.gob.pa/onpar", true);
            }
            else
            {
                if (ViewState["vistaMiaAsociado"] != null) vistaMiaAsociado = (int)ViewState["vistaMiaAsociado"];
                if (ViewState["miaAsociado"] != null) miaAsociado = (string)ViewState["miaAsociado"];
                if (ViewState["despachoCoordinador"] != null) miaAsociado = (string)ViewState["despachoCoordinador"];
                //Response.Cache.SetCacheability(HttpCacheability.ServerAndNoCache);
                if (!IsPostBack)
                {
                    //0. Variable Generales: Defino el Directorio Temporal Cache para los documentos subidos
                    var contexto = Global.Contexto();
                    if (Directorio == null)
                    {
                        var i = contexto.Cache.Directorios.Agregar();
                        Directorio = contexto.Cache.Directorios[i];
                    }
                    //1. Obtener los valores del MIA para establecer componentes visibles
                    //2. Con los componentes visibles sacar los títulos 
                    //3. Con los parámetros de listados se procede a llenarlos
                    CargarInfoFormulario(GlobalSettingsData.MoldeTramiteSolicitud);
                    CargarParametrosMia(miaAsociado, vistaMiaAsociado, null);
                }
                else
                {
                    this.ONSOL_familiares_solicitantes.Rebind();
                    this.ONSOL_paises_de_transito.Rebind();
                }
            }

        }
        /// <summary>
        /// Confirma que la IP sea de Panamá y esté en el listado autorizado
        /// </summary>
        /// <param name="ip"></param>
        /// <returns></returns>
        private bool EsRequestIpValida(ref string ip)
        {
            bool result = false;
            ip = GlobalSettingsData.GetIPSolicitante;
            if (ip == "::1") { return true; }//Cuando es una petición local va directamente

            //Confirmo que sea una IP del rango de IPS autorizadas
            String[] rangosIpInterna = WebConfigurationManager.AppSettings["IPsAutorizadas"].Split(',');
            foreach (string rangoIp in rangosIpInterna)
            {
                var rng = IPAddressRange.Parse(rangoIp);
                if (rng.Contains(IPAddress.Parse(ip))) { result = true; break; }  // is True.
            }
            return result;
            //Pregunto si no ha cambiado el resultado y si sigue falso verifico que sea en Panamá
            //if (!result)
            //{
            //    var llamada = AppConfiguration.GetLlamadaApiPais;
            //    result = true;
            //    try
            //    {
            //        HttpWebRequest request;
            //        request = WebRequest.Create(AppConfiguration.GetLlamadaApiPais) as HttpWebRequest;
            //        request.Timeout = 10 * 1000;
            //        request.Method = "GET";
            //        request.ContentType = "text/html; charset=utf-8";
            //        HttpWebResponse getResponsePais = request.GetResponse() as HttpWebResponse;
            //        StreamReader reader = new StreamReader(getResponsePais.GetResponseStream());
            //        string body = reader.ReadToEnd().Replace("\n", "");
            //        result = (body == "PA");
            //    }
            //    catch (WebException we)
            //    {
            //        HttpWebResponse errorResponse = we.Response as HttpWebResponse;
            //        if (errorResponse.StatusCode == HttpStatusCode.NotFound)
            //        {
            //            sEvent = String.Concat(String.Format("Error al verificar IP: {0} ->", ip), we.Message);
            //            EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 0);
            //        }
            //    }
            //}
        }

        /// <summary>
        /// Carga la información del formulario
        /// </summary>
        /// <param name="codigo">Código del formulario</param>
        private void CargarInfoFormulario(int codigo)
        {
            var formulario = new TSigMoldeTramite()
            {
                Contexto = Global.Contexto()
            };
            formulario.AsignarCodigo(codigo); //MLHIDE
            if (formulario.Obtener())
            {
                //Variables globales
                vistaMiaAsociado = formulario.Vista;
                if (formulario.UsaMia) miaAsociado = formulario.Mia;
                despachoCoordinador = formulario.DespachoCoordinador;
            }
        }

        private void CargarParametrosMia(string mia, int vista, string objetopadre)
        {
            TsigContexto contexto = Global.Contexto();
            var formMia = new TSigMiaVistaTramite
            {
                Contexto = contexto,
                CodigoMia = mia,
                CodigoVista = vista
            };
            string idObjeto = String.Empty;
            if (formMia.Obtener())
            {
                Control objeto;
                DataTable tablaEstructura = formMia.EstructuraVista.Tables[0];
                foreach (DataRow fila in tablaEstructura.Rows)
                {
                    idObjeto = String.Concat(values: new string[] { objetopadre, objetopadre != null ? "_" : "", mia, "_", Convert.ToString(fila["nombre_columna"]) });
                    foreach (RadWizardStep paso in RadWizardSolicitud.WizardSteps) //Se deben recorrer todos los controles de zona del componente
                    {
                        objeto = paso.FindControl(idObjeto);
                        if (objeto != null)
                        {
                            var etiqueta = paso.FindControl("lbl_" + idObjeto) as RadLabel;
                            ConfigurarObjetoMia(etiqueta, objeto, fila);
                            break;
                        }
                    }
                }
            }
        }

        private void CargarParametrosGrilla(Control objeto, string mia, int vista, int tipo_actualizacion)
        {
            TsigContexto contexto = Global.Contexto();
            var formMia = new TSigMiaVistaTramite();
            formMia.Contexto = contexto;
            formMia.CodigoMia = mia;
            formMia.CodigoVista = vista;
            var grilla = (RadGrid)objeto;
            if (formMia.Obtener())
            {
                DataTable tablaEstructura = formMia.EstructuraVista.Tables[0];
                foreach (DataRow fila in tablaEstructura.Rows)
                {
                    if (Convert.ToInt32(fila["grilla_visible"]) == 1)
                    {
                        switch (fila["tipo"])
                        {
                            case 'T':
                                GridDropDownColumn colClasif = new GridDropDownColumn
                                {
                                    HeaderText = Convert.ToString(fila["objeto_caption"]),
                                    ListDataMember = "paises",
                                    DataField = "nombre_pais",
                                    ListValueField = "clave",
                                    ListTextField = "descrip",
                                };
                                break;
                            case 'F':
                                GridDateTimeColumn colFecha = new GridDateTimeColumn();
                                break;
                            case '2':
                                GridDropDownColumn colValorPreestructurado = new GridDropDownColumn();
                                break;
                            case "C":
                                GridBoundColumn colCaracter = new GridBoundColumn();
                                grilla.MasterTableView.Columns.Add(colCaracter);
                                break;
                            default:
                                break;
                        }

                    }
                }
            }
        }

        private void ConfigurarObjetoMia(RadLabel etiqueta, Control objeto, DataRow fila)
        {
            var sql = new StringBuilder();

            if (etiqueta != null) etiqueta.Text = String.Concat("&nbsp;&nbsp;", Convert.ToString(fila["objeto_caption"]));
            try
            {
                string imagen = String.Empty; //para imágenes de RadComboBox
                TsigContexto contexto = Global.Contexto();
                switch (Convert.ToChar(fila["tipo"]))
                {
                    case 'C': //El objeto es un RadTextBox línea simple
                        break;
                    case 'F': //El objeto es un RadCalendar
                        var campoFecha = (RadDatePicker)objeto;
                        campoFecha.DateInput.DisplayDateFormat = "dd MMMM yyyy";
                        campoFecha.MinDate = DateTime.Parse(s: "01/01/1900");
                        break;
                    case 'S': //El objeto es un Texto Simple
                        break;
                    case 'V': //El objeto es RadComboBox que hace una consulta Valor Query
                        sql.Clear();
                        var comboQuery = (RadComboBox)objeto;
                        TRLAQuery consultasql = contexto.BaseDatos.Query();
                        sql.AppendLine(value: Convert.ToString(fila["query_externo"]));
                        consultasql.AgregarSQL(sql.ToString());
                        UniDataReader registro = consultasql.AbrirDataReader();
                        if ((registro != null) && registro.HasRows)
                        {
                            try
                            {
                                while (registro.Read())
                                {
                                    var itemValorQuery = new RadComboBoxItem();
                                    string linea = registro.GetString(0);
                                    itemValorQuery.Value = linea.StartsWith(value: "##") && linea.IndexOf(value: "==") > 0 ? linea.Substring(startIndex: 2, length: linea.IndexOf(value: "==") - 2) : linea;
                                    itemValorQuery.Text = itemValorQuery.Value != linea ? linea.Substring(linea.IndexOf(value: "==") + 2) : linea;
                                    imagen = "~/images/ItemValues/" + itemValorQuery.Value.ToString() + ".png";
                                    string rutaImagen = Server.MapPath(imagen);
                                    if (File.Exists(rutaImagen)) itemValorQuery.ImageUrl = imagen;
                                    comboQuery.Items.Add(itemValorQuery);
                                }
                            }
                            finally
                            {
                                registro.Close();
                            }
                        }
                        break;
                    case 'T': //El objeto es un RadComboBox o un RadTreeView Clasificador depende del tipo de despliegue
                        sql.Clear();
                        var comboClasif = (RadComboBox)objeto;
                        var lista = new TDatosGenerales();
                        TSigConsultasOnpar clasificadores = TSigConsultasOnpar.OnparObtenerClasificadores;
                        comboClasif.DataSource = lista.ObtenerListaClasificadores(Convert.ToString(fila["clasif"]), Convert.ToInt16(fila["nivel"]), clasificadores);
                        comboClasif.DataValueField = "clave";
                        comboClasif.DataTextField = "descrip";
                        comboClasif.DataBind();
                        break;
                    case 'J': //El objeto es un RadNumericTextBox tipo moneda
                        var txtxMoneda = (RadNumericTextBox)objeto;
                        txtxMoneda.EnabledStyle.HorizontalAlign = HorizontalAlign.Right;
                        break;
                    case 'K': //El objeto es una grilla que apunta a otro MIA o es un Hiden que indica campos del MIA destino
                        string mia = Convert.ToString(fila["codigo_arbol_relacion"]);
                        int vista = Convert.ToInt16(GetValueFromProperties(fila["propiedades"], valor: "VISTA_RELACIONADA"));
                        if (vista == 0) vista = Convert.ToInt16(fila["codigo_vista_relacion"]); // Se toma en cuenta la vista de la estructura del MIA (info_col)
                        if (objeto.GetType().Name == "HiddenField") CargarParametrosMia(mia, vista, objeto.ID);
                        else
                        {
                            //CargarParametrosGrilla(objeto, mia, vista, Convert.ToInt16(fila["tipo_actualizacion"]));
                            RadGrid grilla = (RadGrid)objeto;
                            grilla.Rebind();
                        }
                        break;
                    case '2': //El objeto es RadComboBox con valores preestructurados
                        string[] lineasEstructura = Regex.Split(Convert.ToString(fila["query_externo"]), pattern: "\r\n");
                        var comboValorPreestructurado = (RadComboBox)objeto;
                        foreach (string linea in lineasEstructura)
                        {
                            if (linea != "")
                            {
                                var itemPreestructurado = new RadComboBoxItem();
                                itemPreestructurado.Value = linea.StartsWith(value: "##") && linea.IndexOf(value: "==") > 0 ? linea.Substring(startIndex: 2, length: linea.IndexOf(value: "==") - 2) : linea;
                                itemPreestructurado.Text = itemPreestructurado.Value != linea ? linea.Substring(linea.IndexOf(value: "==") + 2) : linea;
                                imagen = "~/images/ItemValues/" + itemPreestructurado.Value.ToString() + ".png";
                                string rutaImagen = Server.MapPath(imagen);
                                if (File.Exists(rutaImagen)) itemPreestructurado.ImageUrl = imagen;
                                comboValorPreestructurado.Items.Add(itemPreestructurado);
                            }

                        }
                        break;
                    case '7': //El objeto es un checkbox
                        var checkboxBoolean = (RadCheckBox)objeto;
                        checkboxBoolean.Text = Convert.ToString(fila["objeto_caption"]);
                        break;
                }
            }
            catch (Exception e)
            {
                Response.Write(e.Message);
            }
        }

        private string GetValueFromProperties(object propiedades, string valor)
        {
            string s = String.Empty;
            string[] claves = Regex.Split(Convert.ToString(propiedades), pattern: "\r\n");
            foreach (string keyvalue in claves)
            {
                if (keyvalue.StartsWith(value: valor))
                {
                    s = keyvalue.Substring(valor.Length + 1);
                    break;
                }
            }
            return s;
        }

        private object GetDataPaisesTransito(int codigoTramite)
        {
            string despacho = String.Empty;
            TsigContexto contexto = Global.Contexto();
            TRLAStoredProc procedimiento = contexto.BaseDatos.StoredProc(procedimiento: TSigConsultasOnpar.OnparObtenerPaisesViaje.ToString());
            despacho = contexto.Despacho.Codigo;
            DataSet dsResultadoGrilla = new DataSet();
            procedimiento.AgregarParametro(Nombre: "CODIGO_SOLICITUD", Tipo: UniDbType.Int).Value = codigoTramite;
            dsResultadoGrilla = procedimiento.AbrirDataSet();
            return (dsResultadoGrilla);
        }

        private object GetDataFamiliares(int codigoTramite)
        {
            string despacho = String.Empty;
            TsigContexto contexto = Global.Contexto();
            TRLAStoredProc procedimiento = contexto.BaseDatos.StoredProc(procedimiento: TSigConsultasOnpar.OnparObtenerFamiliares.ToString());
            despacho = contexto.Despacho.Codigo;
            DataSet dsResultadoGrilla = new DataSet();
            procedimiento.AgregarParametro(Nombre: "CODIGO_SOLICITUD", Tipo: UniDbType.Int).Value = codigoTramite;
            dsResultadoGrilla = procedimiento.AbrirDataSet();
            return (dsResultadoGrilla);
        }

        #region Grilla Países de tránsito
        protected void ONSOL_paises_de_transito_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            (sender as RadGrid).DataSource = GetDataPaisesTransito(id);
        }
        protected void ONSOL_paises_de_transito_ColumnCreated(object sender, GridColumnCreatedEventArgs e)
        {
            if (e.Column.UniqueName == "AutoGeneratedDeleteColumn")
            {
                (e.Column as GridButtonColumn).HeaderStyle.Width = 60;
                (e.Column as GridButtonColumn).ItemStyle.Width = 60;
                (e.Column as GridButtonColumn).ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                (e.Column as GridButtonColumn).HeaderTooltip = "Borrar";
            }
        }
        protected void ONSOL_paises_de_transito_PreRender(object sender, EventArgs e)
        {
            RadComboBox combo = ((sender as RadGrid).MasterTableView.GetBatchEditorContainer("nombre_pais").FindControl("ONSOL_paises_de_transito_ONPTR_nombre_pais") as RadComboBox);
            TDatosGenerales dg = new TDatosGenerales();
            combo.DataSource = dg.Obtener(TCacheDatos.Paises);
            combo.DataValueField = "clave";
            combo.DataTextField = "descrip";
            combo.DataBind();
        }
        #endregion
        #region Grilla Familiares
        protected void ONSOL_familiares_solicitantes_PreRender(object sender, EventArgs e)
        {
            RadComboBox combo = ((sender as RadGrid).MasterTableView.GetBatchEditorContainer("pais_residencia").FindControl("ONSOL_datos_solicitante_ONPER_pais_residencia") as RadComboBox);
            TDatosGenerales dg = new TDatosGenerales();
            combo.DataSource = dg.Obtener(TCacheDatos.Paises);
            combo.DataValueField = "clave";
            combo.DataTextField = "descrip";
            combo.DataBind();
        }
        protected void ONSOL_familiares_solicitantes_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            (sender as RadGrid).DataSource = GetDataFamiliares(id);
        }
        protected void ONSOL_familiares_solicitantes_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                if (!(e.Item is IGridInsertItem))
                {
                    RadComboBox combo = (RadComboBox)item.FindControl("ONSOL_datos_solicitante_ONPER_pais_residencia");
                    var dg = new TDatosGenerales();
                    combo.DataSource = dg.Obtener(TCacheDatos.Paises);
                    combo.DataValueField = "clave";
                    combo.DataTextField = "descrip";
                    combo.DataBind();

                    //RadComboBoxItem selectedItem = new RadComboBoxItem();
                    //selectedItem.Text = ((DataRowView)e.Item.DataItem)["CompanyName"].ToString();
                    //selectedItem.Value = ((DataRowView)e.Item.DataItem)["SupplierID"].ToString();
                    //selectedItem.Attributes.Add("ContactName", ((DataRowView)e.Item.DataItem)["ContactName"].ToString());

                    //combo.Items.Add(selectedItem);

                    //selectedItem.DataBind();

                    //Session["SupplierID"] = selectedItem.Value;
                }
            }
        }
        protected void ONSOL_familiares_solicitantes_ColumnCreated(object sender, GridColumnCreatedEventArgs e)
        {
            if (e.Column.UniqueName == "AutoGeneratedDeleteColumn")
            {
                (e.Column as GridButtonColumn).HeaderStyle.Width = 60;
                (e.Column as GridButtonColumn).ItemStyle.Width = 60;
                (e.Column as GridButtonColumn).ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                (e.Column as GridButtonColumn).HeaderTooltip = "Borrar";
                //(e.Column as GridButtonColumn).Text = "Borrar";
            }
        }
        #endregion

        protected void RadWizardSolicitud_FinishButtonClick(object sender, WizardEventArgs e)
        {
            try
            {
                Boolean result = false;
                int resultadoInsertarTramite = 0;
                long codigoCaso = 0;
                Int64 registroMia = 0;
                DateTime FechaCitaRegistro;
                //Guardar datos en MIA Temporal
                FechaCitaRegistro = AppConfiguration.FechaInicioCitas();
                if (GuardarTramiteWebTemporal(ref registroMia, ref FechaCitaRegistro))
                {
                    // Se notifica del éxito al usuario de la web y se setea como true la variable de resultado.
                    var NotaExito = new StringBuilder();
                    NotaExito.AppendLine(WebConfigurationManager.AppSettings["titulo"] + " - " + WebConfigurationManager.AppSettings["titulosecundario"]);
                    NotaExito.AppendLine("Solicitud generada desde la página web de ONPAR el " + DateTime.Now.ToLongDateString());
                    NotaExito.AppendLine("<span style='font-weight:bold;'>Código de registro en línea:" + registroMia.ToString() + "</span>");
                    NotaExito.AppendLine("Solicitante: " + ONSOL_datos_solicitante_ONPER_nombres.Text + " " + ONSOL_datos_solicitante_ONPER_apellidos.Text);
                    NotaExito.AppendLine("País de origen del solicitante: " + ONSOL_datos_solicitante_ONPER_pais_residencia.Text);
                    lblMensajeFinal.Text = NotaExito.Replace("\r\n", "<br />").ToString();
                    lblFechaRegistro.Text = lblFechaRegistro.Text + FechaCitaRegistro.ToLongDateString();
                    lblFechaRegistro.Text = String.Concat(lblFechaRegistro.Text, "<br /><b>Este documento NO es válido como comprobante de Solicitud de Refugio.</b>");
                    result = true;
                }
                if (result) //Se insertó correctamente la solicitud vía Web
                {
                    if (!CrearCasoTramite(registroMia, ref resultadoInsertarTramite, ref codigoCaso)) { NotificarErrorRegistro(resultadoInsertarTramite, codigoCaso); }
                }
                else
                {
                    lblMensajeFinal.Text = "Error en el registro y envío de la solicitud. Intente de nuevo más tarde.";
                    lblFechaRegistro.Text = "Para más información póngase en contacto con las oficinas de ONPAR, Télf: 512-7228 / 512-7230.";
                }
            }
            catch (Exception ex)
            {
                lblMensajeFinal.BackColor = Color.IndianRed;
                lblMensajeFinal.ForeColor = Color.White;
                lblMensajeFinal.Text = String.Concat("Error: ", ex.Message);
            }
        }

        private void NotificarErrorRegistro(int resultado, long caso)
        {
            var NotaError = new StringBuilder();
            string FechaOriginal = String.Empty;
            string FechaLlegada = String.Empty;
            string NroDocumento = String.Empty;
            string FechaEntrevista = String.Empty;
            NotaError.AppendLine(WebConfigurationManager.AppSettings["titulo"] + " - " + WebConfigurationManager.AppSettings["titulosecundario"]);
            var tramiteOriginal = new TSigCasoTramite() { Contexto = Global.Contexto() };
            tramiteOriginal.AsignarCodigo(caso);
            if (tramiteOriginal.Obtener())
            {
                long regMIA = tramiteOriginal.CodigoMia;
                hfCodigoRegistroMia.Value = regMIA.ToString();
                TsigContexto contexto = Global.Contexto();
                TRLAStoredProc procedimiento = contexto.BaseDatos.StoredProc(TSigProcedures. .ToString());
                procedimiento.AgregarParametro(Nombre: "CODIGO_MIA", Tipo: UniDbType.Int).Value = regMIA; //Código del MIA de ONSOL
                UniDataReader registro = procedimiento.AbrirDataReader();
                if ((registro != null) && registro.HasRows)
                {
                    if (registro["no_de_pasaporte"] != DBNull.Value) NroDocumento = String.Concat("Documento de identidad: ", CampoSQL.AsString(registro["no_de_pasaporte"]));
                    if (registro["fecha_llegada_panama"] != DBNull.Value) FechaLlegada = String.Concat("Fecha de ingreso a Panamá: ", CampoSQL.AsDateTime(registro["fecha_llegada_panama"]).ToLongDateString());
                    if (registro["fecha_registro"] != DBNull.Value) FechaOriginal = String.Concat("Fecha de solicitud original: ", CampoSQL.AsDateTime(registro["fecha_registro"]).ToLongDateString());

                    if (registro["fecha_programada_entrevista"] != DBNull.Value) FechaEntrevista = String.Concat("Fecha de entrevista: ", CampoSQL.AsDateTime(registro["fecha_programada_entrevista"]).ToLongDateString());
                    else FechaEntrevista = "No ha formalizado su Solicitud de Refugio (no se ha presentado en ONPAR).";
                }
            }
            switch (resultado)
            {
                case 1:
                    NotaError.AppendLine("<span style='font-weight:bold;color:red;'>ERROR:</span> Problemas para insertar el trámite en el sistema de ONPAR." + DateTime.Now.ToLongDateString());
                    NotaError.AppendLine("Fecha de transacción: " + DateTime.Now.ToLongDateString());
                    NotaError.AppendLine("Solicitante: " + ONSOL_datos_solicitante_ONPER_nombres.Text + " " + ONSOL_datos_solicitante_ONPER_apellidos.Text);
                    NotaError.AppendLine("País de origen del solicitante: " + ONSOL_datos_solicitante_ONPER_pais_residencia.Text);
                    break;
                case 2:
                    NotaError.AppendLine("<span style='font-weight:bold;color:red;'>ALERTA:</span> Registro duplicado del solicitante.");
                    NotaError.AppendLine("Fecha transacción: " + DateTime.Now.ToLongDateString());
                    NotaError.AppendLine("Solicitante: " + ONSOL_datos_solicitante_ONPER_nombres.Text + " " + ONSOL_datos_solicitante_ONPER_apellidos.Text);
                    NotaError.AppendLine("País de origen del solicitante: " + ONSOL_datos_solicitante_ONPER_pais_residencia.Text);
                    NotaError.Append("<hr />");
                    NotaError.AppendLine(NroDocumento);
                    NotaError.AppendLine(FechaOriginal);
                    NotaError.AppendLine(FechaLlegada);
                    NotaError.AppendLine(FechaEntrevista);
                    lblMensajeFinal.Text = NotaError.ToString();
                    //Actualizo elementos de la vista y deshabilito botones
                    lblMensajeTitulo.Text = "Hubo un error al intentar enviar su solicitud.";
                    lblCopiaMail.Visible = false;
                    RbtImprimir.Visible = false;
                    break;
                default:
                    NotaError.AppendLine("<span style='font-weight:bold;color:red;'>ERROR:</span> Problemas para registro de información." + DateTime.Now.ToLongDateString());
                    NotaError.AppendLine("Fecha transacción: " + DateTime.Now.ToLongDateString());
                    NotaError.AppendLine("Solicitante: " + ONSOL_datos_solicitante_ONPER_nombres.Text + " " + ONSOL_datos_solicitante_ONPER_apellidos.Text);
                    NotaError.AppendLine("País de origen del solicitante: " + ONSOL_datos_solicitante_ONPER_pais_residencia.Text);
                    lblMensajeFinal.Text = NotaError.ToString();
                    break;
            }
            lblMensajeFinal.Text = NotaError.Replace("\r\n", "<br />").ToString();
            lblFechaRegistro.Text = "Este documento NO es válido como comprobante de Solicitud de Refugio.<br />Para más información póngase en contacto con las oficinas de ONPAR, Télf: 512-7228 / 512-7230.";
        }

        /// <summary>
        /// Obtener datos de familares
        /// </summary>
        /// <param name="stringFamiliares"></param>
        /// <param name="dimension"></param>
        /// <returns></returns>
        private List<Familiares> GetDataFamiliares(string stringFamiliares, int dimension)
        {
            string[] lineasEstructura = Regex.Split(Convert.ToString(stringFamiliares), pattern: ",");
            List<Familiares> ListaResultado = new List<Familiares>();
            Familiares persona = null;
            for (int i = 0; i < lineasEstructura.Length; i++)
            {
                string valor = lineasEstructura.GetValue(i).ToString();
                switch (i % dimension)
                {
                    case 0: //Apellidos
                        persona = new Familiares();
                        persona.Apellidos = valor;
                        break;
                    case 1: //Nombres
                        persona.Nombres = valor;
                        break;
                    case 2: //Fecha
                        DateTime.TryParse(valor, out DateTime f);
                        persona.FechaNacimiento = f;
                        break;
                    case 3: //Tipo relación
                        persona.TipoRelacion = valor;
                        break;
                    case 4: //País
                        persona.TipoRelacion = valor;
                        break;
                    case 5: //Ciudad
                        persona.TipoRelacion = valor;
                        ListaResultado.Add(persona);
                        break;
                    default:
                        break;
                }
            }
            return ListaResultado;
        }

        private bool GuardarTramiteWebTemporal(ref long registroMia, ref DateTime cita)
        {
            bool resultado = false;
            try
            {
                var tramiteWeb = new TSigPresentacionWebTemporal()
                {
                    Contexto = Global.Contexto(),
                    NombreMIA = AppConfiguration.MiaTemporalWeb,
                    VistaMia = 1,
                    DespachoRegistrador = Global.Contexto().Despacho.Codigo
                };
                if (tramiteWeb.Insertar())
                {
                    //Datos del solicitante
                    tramiteWeb.TipoIdentificacion = ONSOL_datos_solicitante_ONPER_tipo_documento_identidad.SelectedItem.Text;
                    tramiteWeb.NumeroIdentificacion = ONSOL_datos_solicitante_ONPER_no_de_pasaporte.Text;
                    tramiteWeb.Apellidos = ONSOL_datos_solicitante_ONPER_apellidos.Text;
                    tramiteWeb.Nombres = ONSOL_datos_solicitante_ONPER_nombres.Text;
                    if (ONSOL_datos_solicitante_ONPER_sexo.SelectedValue != "") tramiteWeb.Sexo = ONSOL_datos_solicitante_ONPER_sexo.SelectedItem.Text;
                    tramiteWeb.FechaNacimiento = ONSOL_datos_solicitante_ONPER_fecha_de_nacimiento.SelectedDate.Value;
                    tramiteWeb.EstadoCivil = ONSOL_datos_solicitante_ONPER_estado_civil.SelectedItem.Text;
                    tramiteWeb.Religion = ONSOL_datos_solicitante_ONPER_religion.Text;
                    tramiteWeb.FuncionarioGobierno = Convert.ToBoolean(ONSOL_datos_solicitante_ONPER_funcionario_gobierno.Checked);
                    tramiteWeb.PaisNacimiento = ONSOL_datos_solicitante_ONPER_pais_de_nacimiento.SelectedItem.Text;
                    tramiteWeb.PaisNacionalidad = ONSOL_datos_solicitante_ONPER_nacionalidad.SelectedItem.Text;
                    tramiteWeb.PaisResidencia = ONSOL_datos_solicitante_ONPER_pais_residencia.SelectedItem.Text;
                    tramiteWeb.CiudadResidencia = ONSOL_datos_solicitante_ONPER_ciudad_residencia.Text;
                    tramiteWeb.Direccion = ONSOL_datos_solicitante_ONPER_direccion_en_panama.Text;
                    tramiteWeb.DireccionPaisOrigen = ONSOL_datos_solicitante_ONPER_direccion_zona_pais_origen.Text;
                    tramiteWeb.Telefono = ONSOL_datos_solicitante_ONPER_telefono_de_contacto.Text;
                    tramiteWeb.Email = ONSOL_datos_solicitante_ONPER_correo_electronico.Text;
                    tramiteWeb.InformacionAdicional = ONSOL_datos_solicitante_ONPER_informacion_adicional.Text;
                    tramiteWeb.CondicionEspecial = Convert.ToBoolean(ONSOL_datos_solicitante_ONPER_codicion_especial.Checked);
                    //Datos de la solicitud
                    tramiteWeb.FechaSalidaPaisOrigen = ONSOL_fecha_salida_pais_origen.SelectedDate.Value;
                    tramiteWeb.FechaLLegadaPais = ONSOL_fecha_llegada_panama.SelectedDate.Value;
                    tramiteWeb.MedioViaje = ONSOL_medios_para_salir_pais.Text;
                    tramiteWeb.ResumenTramite = ONSOL_resumen_tramite.Text;
                    tramiteWeb.TemorRetorno = ONSOL_temores_de_retorno.Text;
                    tramiteWeb.AgentePersecutor = ONSOL_agente_persecutor.Text;
                    tramiteWeb.EleccionDestinoPanama = ONSOL_eleccion_destino.Text;
                    tramiteWeb.DatosMiaFamiliares = hFamiliares.Value;
                    tramiteWeb.DatosMiaPaisesTransito = hPaisesViaje.Value;
                    //Datos de control
                    tramiteWeb.IP = AppConfiguration.GetIPSolicitante;
                    if (tramiteWeb.Guardar())
                    {
                        tramiteWeb.CitasxDia = AppConfiguration.NumeroCitasDiarias;
                        tramiteWeb.FechaBaseCitas = cita;
                        cita = tramiteWeb.GetFechaPresentacion();
                        tramiteWeb.FechaCitaProgramada = cita;
                        registroMia = tramiteWeb.Codigo;
                        resultado = tramiteWeb.Guardar();
                    }
                }
            }
            catch (Exception ex) { Console.WriteLine("Error: " + ex.Message); }
            finally { }
            return resultado;
        }

        private bool CrearCasoTramite(long registroMiaTemporal, ref int resultado_operacion, ref long codigo_caso)
        {
            bool resultado = false;
            var ResumenCasoTramite = new StringBuilder();
            var NotaEnvio = new StringBuilder();
            string DescripcionEstado = String.Empty;
            try
            {
                string TituloCasoTramite = String.Concat(Page.Title, " de ", ONSOL_datos_solicitante_ONPER_apellidos.Text, " ", ONSOL_datos_solicitante_ONPER_nombres.Text, "(", ONSOL_datos_solicitante_ONPER_pais_residencia.Text, ")");
                ResumenCasoTramite.AppendLine("Solicitud generada a través del formulario en línea de la Oficina Nacional para los Refugiados");
                ResumenCasoTramite.AppendLine("Fecha y hora de solicitud: " + DateTime.Today.ToLongTimeString());
                ResumenCasoTramite.AppendLine("País de origen del solicitante: " + ONSOL_datos_solicitante_ONPER_pais_residencia.Text);
                ResumenCasoTramite.AppendLine("Solicitante: " + ONSOL_datos_solicitante_ONPER_nombres.Text + " " + ONSOL_datos_solicitante_ONPER_apellidos.Text);
                //Recupero el modo de inicio del trámite en el TRE
                int modoInicio = AppConfiguration.ModoInicioTramite;
                var Lista = new Estado();
                var EstadosTre = Lista.ListaEstados();
                DescripcionEstado = EstadosTre.Find(x => x.EstadoCodigo == AppConfiguration.ModoInicioTramite).EstadoNombre;
                // Inicio la clase para insertar el trámite
                var tramite = new TSigCasoTramite()
                {
                    Contexto = Global.Contexto(),
                    MoldeTramite = AppConfiguration.MoldeTramiteSolicitud,
                    DespachoOriginador = Global.Contexto().Despacho.Codigo,
                    Estado = Convert.ToInt32(TSigEstadoTramite.PropuestaEnElaboracionDespachoOriginador),
                    CodigoRegistroMiaWeb = registroMiaTemporal
                };
                if (tramite.Insertar())
                {
                    if (tramite.Obtener())
                    {
                        hfCodigoRegistroMia.Value = tramite.CodigoMia.ToString();
                        NotaEnvio.AppendLine("Solicitud generada desde la página web el " + DateTime.Now.ToLongDateString());
                        NotaEnvio.AppendLine("Código de registro en módulo web: " + registroMiaTemporal.ToString() + ", desde la IP [" + AppConfiguration.GetIPSolicitante + "]");
                        NotaEnvio.Append("Revisar y verificar que el contenido sea correcto antes de aprobar su inicio (Pasaportes y datos de solicitante y familiares");
                        //Actualizar los datos del trámite y enviarlo a revisión
                        tramite.NotaEnvio = NotaEnvio.ToString();
                        tramite.Estado = modoInicio;
                        tramite.FechaEnvioTramite = DateTime.Now;
                        tramite.DespachoRegistrador = tramite.DespachoOriginador;
                        if (tramite.Guardar())
                        {
                            resultado = true;
                            //Actualizo el dato de la nota de envío para aprobación 
                            tramite.ResumenHtml = tramite.CovertirResumenHtml(tramite.TituloCasoTramite, tramite.ResumenCaso);
                            if (!tramite.Guardar()) { tramite.EscribirLog(String.Format("No se pudo guardar el resumen del caso: {0}", tramite.Codigo)); }
                        }
                    }
                }
                else
                {
                    tramite.EscribirLog("No se pudo insertar el trámite: " + tramite.ErrorSQL);
                }
                resultado_operacion = tramite.ResultadoOperacion;
                codigo_caso = tramite.Codigo;
            }
            catch (Exception ex) { Console.Write("Error: " + ex.Message); }
            finally { };
            return resultado;
        }
        protected void RbtImprimir_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "PrintOperation", "printing()", true);
        }

        /// <summary>
        /// Genera el código QR para el registro en línea
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RCodeQRSolicitud_PreRender(object sender, EventArgs e)
        {
            string urlQR = Request.Url.Scheme + System.Uri.SchemeDelimiter + Request.Url.Authority + String.Format("/Gestion/ComprobanteSolicitud.aspx?CODIGO={0}", hfCodigoRegistroMia.Value);
            if (!IsPostBack || !String.IsNullOrEmpty(hfCodigoRegistroMia.Value))
            {
                try
                {
                    //String strUrl = HttpContext.Current.Request.Url.AbsoluteUri.Replace(HttpContext.Current.Request.Url.PathAndQuery, HttpContext.Current.Request.ApplicationPath == "/" ? "" : HttpContext.Current.Request.ApplicationPath);
                    RadBarcode QR = (RadBarcode)sender;
                    QR.Text = @urlQR;
                    QR.QRCodeSettings.ECI = Modes.ECIMode.None;
                    QR.QRCodeSettings.ErrorCorrectionLevel = Modes.ErrorCorrectionLevel.L;
                    QR.QRCodeSettings.Mode = Modes.CodeMode.Byte;
                    QR.QRCodeSettings.Version = 0;
                    QR.OutputType = BarcodeOutputType.EmbeddedPNG;
                }

                catch (Exception ex)
                {
                    sEvent = String.Concat("Error al generar código QR: ", ex.Message);
                    EventLog.WriteEntry(sSource, sEvent, EventLogEntryType.Error, 0);
                }
            }
        }
    }

    /// <summary>
    /// Clase de Familiares del solicitante
    /// </summary>
    internal class Familiares
    {
        public string Apellidos { get; set; }
        public string Nombres { get; set; }
        public string Sexo { get; set; }
        public string TipoRelacion { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string Pais { get; set; }
        public string Ciudad { get; set; }
    }
}