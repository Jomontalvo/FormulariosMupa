namespace FormulariosMupa.App_Code
{
    public enum TCacheData : int
    {
        Countries = 0,
        Provinces = 1,
        Cities = 2,
        Offices = 3

    }

    public enum TSigCorrespondenceProcedures: int
    {
        SvconObtenerMenuServicios = 0,
        SvconObtenerDetallesLlamadaFormulario = 1,
        SvconObtenerMoldeTre = 2,
        SvconMiaRelacionado = 3,
        SvconObtenerDatosPersona = 4,
        SvconObtenerPaises = 5,
        SvconObtenerClasificadores = 6,
        SvconDocumentosTramite = 7,
        SvconObtenerTarifaServicioVigente = 8,
        SvconObtenerTarifaMonedaLocal = 9,
        SvconObtenerInfoMiaTramite = 10,
        SvconObtenerBitacoraTramite = 11,
        SvconExistePersona = 12,
        SvcInsertarRelacionSolicitante = 13,
        SvconInsertarRegistroMia = 14,
        SvconObtenerDespachoRevisor = 15,
        SvconDocumentosMiaTramite = 16,
        TreInsertarCaso = 17,
        TreEliminarTramite = 18,
        TreEstructuraTramite = 19,
        SvconObtenerCorrespondenciaViaWeb = 20,
        SvconSolicitudesAprobacion = 21,
        TreObtenerPropuestasAprobacion = 22,
        TreObtenerPropuestas = 23,
        TreObtenerPropuestasPedidoEliminacion = 24,
        TreObtenerMoldeDocumentos = 25,
        TrePuedeAprobarPropuesta = 26,
        TreIniciarTramite = 27,
        SvconObtenerDocumentosMiaTramite = 28,
        SvconSubirDocumentoMIA = 29,
        RepGenerarTicket = 30
    }
}