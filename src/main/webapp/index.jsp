<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

    <title>C. Baloncesto</title>
</head>

<body>
<div class="container">
    <br><br>
    <div class="panel panel-primary">
        <div class="panel-heading text-center"><h2>Club de Baloncesto</h2></div>
        <%
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager
                    .getConnection("jdbc:postgresql://127.0.0.1:5432/baloncesto",
                            "postgres",
                            "secret");
            Statement s = conexion.createStatement();

            ResultSet listado = s.executeQuery ("SELECT * FROM socio");
        %>

        <table class="table table-striped">
            <tr><th>Nº de socio</th><th>Nombre</th><th>Estatura</th><th>Edad</th><th>Localidad</th></tr>
            <form method="get" action="grabaSocio.jsp">
                <tr><td><input type="text" name="socioID" size="5"></td>
                    <td><input type="text" name="nombre" size="30"></td>
                    <td><input type="text" name="estatura" size="5"></td>
                    <td><input type="text" name="edad" size="5"></td>
                    <td><input type="text" name="localidad" size="20"></td>
                    <td><button type="submit" value="Añadir" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> Añadir</button></td><td></td></tr>
            </form>
            <%
                while (listado.next()) {
                    out.println("<tr><td>");
                    out.println(listado.getString("socioID") + "</td>");
                    out.println("<td>" + listado.getString("nombre") + "</td>");
                    out.println("<td>" + listado.getString("estatura") + "</td>");
                    out.println("<td>" + listado.getString("edad") + "</td>");
                    out.println("<td>" + listado.getString("localidad") + "</td>");
            %>
            <td>
                <form method="get" action="modificaSocio.jsp">
                    <input type="hidden" name="socioID" value="<%=listado.getString("socioID") %>">
                    <input type="hidden" name="nombre" value="<%=listado.getString("nombre") %>">
                    <input type="hidden" name="estatura" value="<%=listado.getString("estatura") %>">
                    <input type="hidden" name="edad" value="<%=listado.getString("edad") %>">
                    <input type="hidden" name="localidad" value="<%=listado.getString("localidad") %>">
                    <button type="submit"  class="btn btn-info"><span class="glyphicon glyphicon-pencil"></span> Modificar</button>
                </form>
            </td>
            <td>
                <form method="get" action="borraSocio.jsp" >
                    <input type="hidden" name="socioID" value="<%=listado.getString("socioID") %>"/>
                    <button class="borra-socio-btn btn btn-danger" data-socio-id="<%=listado.getString("socioID") %>"  <%--onclick="borra(this)"--%>><span class="glyphicon glyphicon-remove"></span> Eliminar</button>
                </form>
            </td></tr>
            <%
                } // while
                conexion.close();
            %>

        </table>
    </div>
</div>
<div id="borra-modal" class="modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Eliminar socio</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Desea eliminar este socio <strong id="num-socio"></strong>?</p>
            </div>
            <div class="modal-footer">
                <button id="borra-save" type="button" class="btn btn-danger">Eliminar</button>
                <button id="borra-close" type="button" class="borra-close btn btn-secondary" data-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {

        document.querySelector('#borra-save').addEventListener('click', function(e) {
            e.target.form_socio_id.submit();
            $('#borra-modal').modal('hide');
        });

        document.querySelector('#borra-close').addEventListener('click', function(e) {
            $('#borra-modal').modal('hide');
        });

        let borraEls = document.querySelectorAll('.borra-socio-btn');
        Array.from(borraEls).forEach((el) => {
            el.addEventListener('click', function (e) {
                //por si se te olvida añadir el.. type="button"
                e.preventDefault();
                document.querySelector('#num-socio').innerText= e.target.getAttribute('data-socio-id');
                document.querySelector('#borra-save').form_socio_id = e.target.parentElement;

                $('#borra-modal').modal('show');
            });
        });
    });
</script>

<%--<script>--%>
<%--    $(function() {--%>

<%--        $('#borra-save').click(function(e){--%>
<%--            $(this).prop('form-socio-id').submit();--%>
<%--            $('#borra-modal').modal('hide');--%>
<%--        });--%>

<%--        $('#borra-close').click(function(e){--%>
<%--            $('#borra-modal').modal('hide');--%>
<%--        });--%>

<%--        $('.borra-socio-btn').click(function(e) {--%>
<%--            //por si se te olvida añadir el.. type="button"--%>
<%--            e.preventDefault();--%>

<%--            $('#borra-save').prop('form-socio-id', $(this).parent());--%>

<%--            $('#borra-modal').modal('show');--%>

<%--        });--%>

<%--    });--%>
<%--</script>--%>
<%--<script>--%>
<%--    $(function() {--%>

<%--        $('.borra-socio-btn').click((e) => {--%>

<%--            e.preventDefault();--%>
<%--            let form = e.target.parentElement;--%>

<%--            $('#borra-save').click((e2) =>{--%>
<%--                form.submit();--%>
<%--                $('#borra-modal').modal('hide');--%>
<%--            });--%>

<%--            $('#borra-close').click((e2) =>{--%>
<%--                $('#borra-modal').modal('hide');--%>
<%--            });--%>

<%--            $('#borra-modal').modal('show');--%>

<%--        });--%>

<%--    });--%>
<%--</script>--%>
<%--<script>--%>
<%--    function borra(elem) {--%>
<%--        if (confirm("Desea borrar el socio?")) {--%>
<%--            elem.parentNode.submit();--%>
<%--        } else {--%>
<%--            event.preventDefault();--%>
<%--        }--%>
<%--    }--%>
<%--</script>--%>
<%--<script>--%>
<%--    let borraEls = document.getElementsByClassName('borra-socio-btn');--%>
<%--    Array.from(borraEls).forEach((el) =>--%>
<%--        el.addEventListener('click', (e) => {--%>
<%--            if (confirm("Desea borrar el socio?")) {--%>
<%--                e.target.parentNode.submit();--%>
<%--            } else {--%>
<%--                e.preventDefault();--%>
<%--            }--%>
<%--        })--%>
<%--    );--%>
<%--</script>--%>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<%--<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>--%>
<%--<script>--%>
<%--    //$(document).ready(function() {...--%>
<%--    //Equivale a esto--%>
<%--    $(function() {--%>
<%--      //Cuando el document se encuentra en estado ready puedes anclar eventos--%>
<%--        $('.borra-socio-btn').click((e) => {--%>
<%--            if (confirm("Desea borrar el socio?")) {--%>
<%--                $(this).parent().submit();--%>
<%--            } else {--%>
<%--                e.preventDefault();--%>
<%--            }--%>
<%--        });--%>

<%--    });--%>
<%--</script>--%>
</body>
</html>