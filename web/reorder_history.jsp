<%@ page import="java.util.List" %>
<%@ page import="com.inventory.model.Reorder" %>

<!DOCTYPE html>
<html>

<head>

<title>Reorder History</title>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>

/* =========================================================
   RESET
========================================================= */

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
}

html,body{
    width:100%;
    min-height:100%;
}

body{
    font-family:"Segoe UI",Arial,sans-serif;
    background:#12090C;
    color:#FFF8EA;
    overflow-x:hidden;
}


/* =========================================================
   DARK INVENTORY LASER BACKGROUND
   STATIC - NO MOTION
========================================================= */

body::before{

    content:"";

    position:fixed;
    inset:0;

    z-index:0;
    pointer-events:none;

    background-color:#12090C;

    /* CONTINUOUS REAL HONEYCOMB */

    background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='156' viewBox='0 0 180 156'%3E%3Cg fill='none' stroke='%23D1A64A' stroke-width='1.5' opacity='.30'%3E%3Cpath d='M45 1 L135 1 L180 78 L135 155 L45 155 L0 78 Z'/%3E%3Cpath d='M-45 1 L45 1 L90 78 L45 155 L-45 155 L-90 78 Z'/%3E%3Cpath d='M135 1 L225 1 L270 78 L225 155 L135 155 L90 78 Z'/%3E%3C/g%3E%3C/svg%3E");

    background-repeat:repeat;

    background-size:180px 156px;

    background-attachment:fixed;

}


/* =========================================================
   INVENTORY LASER ART
   STATIC - NO MOTION
========================================================= */

body::after{

    content:"";

    position:fixed;
    inset:0;

    z-index:0;
    pointer-events:none;

    opacity:.42;

    background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='900' height='650' viewBox='0 0 900 650'%3E%3Cdefs%3E%3Cfilter id='glow'%3E%3CfeGaussianBlur stdDeviation='3' result='blur'/%3E%3CfeMerge%3E%3CfeMergeNode in='blur'/%3E%3CfeMergeNode in='SourceGraphic'/%3E%3C/feMerge%3E%3C/filter%3E%3C/defs%3E%3Cg fill='none' stroke='%23D5A94F' stroke-width='2' opacity='.70' filter='url(%23glow)'%3E%3C!-- warehouse box --%3E%3Crect x='40' y='65' width='125' height='90' rx='4'/%3E%3Cpath d='M40 95 L102 128 L165 95 M102 128V155 M102 65V128'/%3E%3Cpath d='M63 78L102 99L142 78'/%3E%3C!-- barcode --%3E%3Cpath d='M220 70V150 M228 70V150 M237 70V150 M250 70V150 M258 70V150 M270 70V150 M283 70V150 M292 70V150 M302 70V150'/%3E%3Cpath d='M210 160H312'/%3E%3C!-- QR --%3E%3Crect x='370' y='55' width='105' height='105' rx='4'/%3E%3Crect x='385' y='70' width='27' height='27'/%3E%3Crect x='433' y='70' width='27' height='27'/%3E%3Crect x='385' y='118' width='27' height='27'/%3E%3Cpath d='M433 118H444V129H457V145H433V137H442V129H433Z'/%3E%3C!-- microchip --%3E%3Crect x='555' y='60' width='105' height='105' rx='10'/%3E%3Crect x='580' y='85' width='55' height='55' rx='5'/%3E%3Cpath d='M570 60V40 M590 60V40 M610 60V40 M630 60V40 M570 165V185 M590 165V185 M610 165V185 M630 165V185 M555 80H535 M555 102H535 M555 124H535 M555 146H535 M660 80H680 M660 102H680 M660 124H680 M660 146H680'/%3E%3C!-- laser network --%3E%3Cpath d='M40 245H180L215 280H350L390 245H535L575 285H760'/%3E%3Cpath d='M105 245V215H180 M350 280V330H470 M535 245V205H630'/%3E%3Ccircle cx='180' cy='245' r='6' fill='%23D5A94F'/%3E%3Ccircle cx='350' cy='280' r='6' fill='%23D5A94F'/%3E%3Ccircle cx='535' cy='245' r='6' fill='%23D5A94F'/%3E%3Ccircle cx='760' cy='285' r='6' fill='%23D5A94F'/%3E%3C!-- shelves --%3E%3Cpath d='M45 390H300 M45 465H300 M45 540H300'/%3E%3Cpath d='M60 370V555 M285 370V555'/%3E%3Crect x='80' y='405' width='60' height='42'/%3E%3Crect x='160' y='405' width='95' height='42'/%3E%3Crect x='75' y='480' width='90' height='42'/%3E%3Crect x='185' y='480' width='70' height='42'/%3E%3C!-- clipboard --%3E%3Crect x='390' y='375' width='135' height='175' rx='8'/%3E%3Crect x='425' y='360' width='65' height='30' rx='8'/%3E%3Cpath d='M415 425H500 M415 455H500 M415 485H485'/%3E%3Cpath d='M415 425L424 434L440 416 M415 455L424 464L440 446'/%3E%3C!-- package label --%3E%3Crect x='600' y='395' width='150' height='90' rx='5'/%3E%3Cpath d='M615 415H680 M615 435H705 M615 455H665'/%3E%3Cpath d='M685 410V470 M692 410V470 M700 410V470 M710 410V470 M720 410V470'/%3E%3C!-- circuit path --%3E%3Cpath d='M590 530H650V570H715V615H850'/%3E%3Cpath d='M650 530V500H700 M715 570V540H770'/%3E%3Ccircle cx='650' cy='530' r='5' fill='%23D5A94F'/%3E%3Ccircle cx='715' cy='570' r='5' fill='%23D5A94F'/%3E%3Ccircle cx='850' cy='615' r='5' fill='%23D5A94F'/%3E%3C/g%3E%3C/svg%3E");

    background-repeat:repeat;

    background-size:900px 650px;

    background-attachment:fixed;

}


/* =========================================================
   EXTRA LASER GLOW
   STATIC
========================================================= */

.page-wrapper::before{

    content:"";

    position:fixed;

    top:18%;
    left:-5%;

    width:110%;

    height:2px;

    z-index:0;

    pointer-events:none;

    background:
        linear-gradient(
            90deg,
            transparent,
            rgba(214,169,79,.65),
            rgba(255,222,139,.95),
            rgba(214,169,79,.65),
            transparent
        );

    box-shadow:
        0 0 8px rgba(214,169,79,.70),
        0 0 22px rgba(214,169,79,.35);

    transform:rotate(-7deg);

}


.page-wrapper::after{

    content:"";

    position:fixed;

    bottom:20%;
    left:-5%;

    width:110%;

    height:1px;

    z-index:0;

    pointer-events:none;

    background:
        linear-gradient(
            90deg,
            transparent,
            rgba(130,38,65,.8),
            rgba(214,169,79,.8),
            rgba(130,38,65,.8),
            transparent
        );

    box-shadow:
        0 0 10px rgba(214,169,79,.35);

    transform:rotate(6deg);

}


/* =========================================================
   PAGE WRAPPER
========================================================= */

.page-wrapper{

    position:relative;

    z-index:1;

    min-height:100vh;

    padding:18px 20px 25px;

}


/* =========================================================
   GLASS MAIN CARD
   STATIC - FLOATING ANIMATION REMOVED
========================================================= */

.card{

    position:relative;

    z-index:2;

    max-width:1180px;

    margin:18px auto;

    padding:28px 30px;

    background:
        linear-gradient(
            145deg,
            rgba(255,253,248,.86),
            rgba(249,240,223,.70)
        );

    backdrop-filter:blur(14px);

    -webkit-backdrop-filter:blur(14px);

    border:2px solid rgba(205,164,78,.90);

    border-radius:20px;

    box-shadow:

        0 30px 65px rgba(0,0,0,.65),

        0 10px 30px rgba(91,20,43,.35),

        0 0 35px rgba(191,145,55,.12),

        inset 0 1px 0 rgba(255,255,255,.95),

        inset 0 -1px 0 rgba(255,255,255,.25);

    /* NO ANIMATION */
    animation:none;

}


/* =========================================================
   GLASS HIGHLIGHT
========================================================= */

.card::before{

    content:"";

    position:absolute;

    inset:0;

    border-radius:18px;

    pointer-events:none;

    background:
        linear-gradient(
            125deg,
            rgba(255,255,255,.28),
            transparent 35%,
            transparent 70%,
            rgba(255,255,255,.10)
        );

}


/* =========================================================
   HEADER
========================================================= */

.header{

    position:relative;

    z-index:3;

    display:flex;

    align-items:center;

    justify-content:space-between;

    gap:20px;

    margin-bottom:24px;

}


.header-left{

    display:flex;

    align-items:center;

    gap:15px;

}


.icon{

    width:50px;

    height:50px;

    display:flex;

    align-items:center;

    justify-content:center;

    background:
        linear-gradient(
            145deg,
            #711F3A,
            #541329
        );

    color:#F3C96B;

    border:1px solid #C69A48;

    border-radius:14px;

    font-size:20px;

    box-shadow:

        0 6px 15px rgba(111,32,56,.40),

        0 0 15px rgba(198,154,72,.16);

}


h1{

    color:#57152C;

    font-size:27px;

    font-weight:750;

    letter-spacing:-.5px;

}


h1 span{

    color:#A87927;

    font-weight:500;

}


/* =========================================================
   TABS
========================================================= */

.tabs{

    display:flex;

    padding:4px;

    background:
        rgba(239,226,201,.72);

    border:1px solid #C9AB70;

    border-radius:13px;

    backdrop-filter:blur(8px);

}


.tabs a{

    text-decoration:none;

    padding:10px 18px;

    border-radius:10px;

    color:#674C4D;

    font-size:13px;

    font-weight:650;

    transition:.2s ease;

}


.tabs a:hover{

    color:#57152C;

    background:rgba(247,235,213,.85);

}


.tabs a.active{

    background:
        linear-gradient(
            135deg,
            #721F3B,
            #5B162F
        );

    color:#FFF8EA;

    border:1px solid #5A152D;

    box-shadow:

        0 5px 14px rgba(91,20,43,.30),

        0 0 10px rgba(198,154,72,.16);

}


/* =========================================================
   SECTION TITLE
========================================================= */

.section-title{

    position:relative;

    z-index:3;

    display:flex;

    align-items:center;

    gap:13px;

    margin-bottom:17px;

}


.section-title h2{

    color:#57152C;

    font-size:20px;

    font-weight:750;

}


.section-line{

    height:2px;

    flex:1;

    background:
        linear-gradient(
            90deg,
            #B78A3A,
            rgba(183,138,58,.35),
            transparent
        );

}


/* =========================================================
   TABLE
========================================================= */

.table-container{

    position:relative;

    z-index:3;

    border:1px solid rgba(205,187,155,.95);

    border-radius:15px;

    overflow:hidden;

    background:
        rgba(255,253,248,.91);

    box-shadow:

        0 8px 20px rgba(70,36,25,.16),

        inset 0 1px 0 rgba(255,255,255,.8);

    backdrop-filter:blur(8px);

}


table{

    width:100%;

    border-collapse:collapse;

}


thead{

    background:
        linear-gradient(
            90deg,
            #671A33,
            #7C2743
        );

    border-bottom:3px solid #C69A48;

}


th{

    padding:15px 16px;

    text-align:left;

    color:#FFE9B2;

    font-size:12px;

    font-weight:750;

    text-transform:uppercase;

    letter-spacing:.6px;

}


td{

    padding:15px 16px;

    color:#422D2E;

    font-size:14px;

    font-weight:500;

    border-bottom:1px solid #E9DDCB;

}


tbody tr{

    background:rgba(255,253,248,.95);

}


tbody tr:nth-child(even){

    background:rgba(248,240,226,.92);

}


tbody tr:hover{

    background:#F3E2CE;

}


tbody tr:last-child td{

    border-bottom:none;

}


td:first-child{

    color:#A47725;

    font-weight:750;

}


td:nth-child(2){

    color:#681A34;

    font-weight:700;

}


td:nth-child(3){

    color:#946C22;

    font-weight:750;

}


/* =========================================================
   STATUS BADGES
========================================================= */

.badge{

    display:inline-flex;

    align-items:center;

    justify-content:center;

    gap:5px;

    min-width:94px;

    padding:6px 14px;

    border-radius:20px;

    font-size:11px;

    font-weight:750;

    border:1px solid transparent;

}


.requested{

    background:#FFF0C9;

    color:#8B6116;

    border-color:#D9B762;

}


.processing{

    background:#E8DFF0;

    color:#654275;

    border-color:#C5B0D0;

}


.completed{

    background:#DDEEDB;

    color:#3E6942;

    border-color:#B5D0B4;

}


/* =========================================================
   EMPTY TABLE
========================================================= */

td[colspan="5"]{

    color:#806C68;

    font-size:14px;

    padding:45px 20px !important;

    text-align:center;

}


/* =========================================================
   PROJECTOR / RESPONSIVE
========================================================= */

@media(max-width:900px){

    .header{

        flex-direction:column;

        align-items:flex-start;

    }


    .tabs{

        width:100%;

    }


    .tabs a{

        flex:1;

        text-align:center;

    }

}


@media(max-width:650px){

    .page-wrapper{

        padding:10px;

    }


    .card{

        padding:20px 16px;

        margin:8px auto;

    }


    h1{

        font-size:22px;

    }


    .header-left{

        gap:10px;

    }


    .icon{

        width:44px;

        height:44px;

    }


    th,
    td{

        padding:11px 9px;

    }


    th{

        font-size:10px;

    }


    td{

        font-size:12px;

    }

}


/* =========================================================
   FINAL STATIC BACKGROUND SAFETY
========================================================= */

body,
body::before,
body::after,
.page-wrapper::before,
.page-wrapper::after,
.card{

    animation:none !important;

}

</style>

</head>


<body>


<div class="page-wrapper">

    <div class="card">


        <!-- HEADER -->

        <div class="header">

            <div class="header-left">

                <div class="icon">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                </div>

                <div>

                    <h1>
                        Reorder <span>History</span>
                    </h1>

                </div>

            </div>


            <!-- NAVIGATION -->

            <div class="tabs">

                <a href="ReorderServlet">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                    Low Stock

                </a>


                <a href="ReorderHistoryServlet"
                   class="active">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    Reorder History

                </a>


                <a href="AnalyticsServlet">

                    <i class="fa-solid fa-chart-line"></i>

                    Analytics

                </a>

            </div>

        </div>


        <!-- SECTION -->

        <div class="section-title">

            <h2>

                <i class="fa-solid fa-boxes-stacked"></i>

                Reorder Records

            </h2>

            <div class="section-line"></div>

        </div>


        <!-- TABLE -->

        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>#</th>

                        <th>
                            Product Name
                        </th>

                        <th>
                            Quantity
                        </th>

                        <th>
                            Date & Time
                        </th>

                        <th>
                            Status
                        </th>

                    </tr>

                </thead>


                <tbody>

                <%

                List<Reorder> reorderList =
                    (List<Reorder>)request.getAttribute("reorderList");


                if(reorderList != null && !reorderList.isEmpty()){

                    int i = 1;


                    for(Reorder r : reorderList){

                        String status = "requested";


                        if("Processing".equalsIgnoreCase(r.getStatus())){

                            status = "processing";

                        }

                        else if("Completed".equalsIgnoreCase(r.getStatus())){

                            status = "completed";

                        }

                %>


                    <tr>

                        <td>
                            <%= i++ %>
                        </td>


                        <td>
                            <%= r.getItemName() %>
                        </td>


                        <td>
                            <%= r.getQuantity() %>
                        </td>


                        <td>
                            <%= r.getReorderDate() %>
                        </td>


                        <td>

                            <span class="badge <%= status %>">

                                <i class="fa-solid
                                <%

                                if("requested".equals(status)){

                                %>
                                    fa-paper-plane
                                <%

                                }
                                else if("processing".equals(status)){

                                %>
                                    fa-spinner
                                <%

                                }
                                else{

                                %>
                                    fa-circle-check
                                <%

                                }

                                %>
                                "></i>

                                <%= r.getStatus() %>

                            </span>

                        </td>

                    </tr>


                <%

                    }

                }

                else{

                %>


                    <tr>

                        <td colspan="5">

                            <i class="fa-solid fa-box-open"
                               style="
                               font-size:28px;
                               color:#B78A3A;
                               display:block;
                               margin-bottom:10px;
                               ">

                            </i>

                            No reorder history available.

                        </td>

                    </tr>


                <%

                }

                %>

                </tbody>

            </table>

        </div>


    </div>

</div>


</body>

</html>
