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

html,
body{
    width:100%;
    min-height:100%;
}


/* =========================================================
   BODY - DASHBOARD TEAL THEME
========================================================= */

body{
    font-family:"Segoe UI",Arial,sans-serif;
    background:#eef6f8;
    color:#243b44;
    overflow-x:hidden;
}


/* =========================================================
   SUBTLE DASHBOARD GRID
========================================================= */

body::before{
    content:"";
    position:fixed;
    inset:0;

    z-index:0;
    pointer-events:none;

    background-image:
        linear-gradient(rgba(40,88,109,.035) 1px, transparent 1px),
        linear-gradient(90deg, rgba(40,88,109,.035) 1px, transparent 1px);

    background-size:42px 42px;
}


/* =========================================================
   PAGE WRAPPER
========================================================= */

.page-wrapper{
    position:relative;
    z-index:1;

    min-height:100vh;

    padding:28px 24px 35px;
}


/* =========================================================
   MAIN CARD
========================================================= */

.card{
    position:relative;
    z-index:2;

    width:100%;
    max-width:1180px;

    margin:0 auto;

    padding:28px 30px;

    background:rgba(255,255,255,.96);

    border:1px solid #c9dce2;

    border-radius:18px;

    box-shadow:
        0 18px 45px rgba(31,70,87,.12),
        0 4px 14px rgba(31,70,87,.06);

    animation:none;
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

    gap:24px;

    margin-bottom:28px;
}


.header-left{
    display:flex;
    align-items:center;

    gap:15px;
}


/* =========================================================
   HEADER ICON
========================================================= */

.icon{
    width:50px;
    height:50px;

    display:flex;
    align-items:center;
    justify-content:center;

    background:
        linear-gradient(
            135deg,
            #28586d,
            #1f4657
        );

    color:#ffffff;

    border-radius:13px;

    font-size:20px;

    box-shadow:
        0 7px 16px rgba(40,88,109,.22);
}


/* =========================================================
   TITLE
========================================================= */

h1{
    color:#243b44;

    font-size:27px;
    font-weight:750;

    letter-spacing:-.5px;
}


h1 span{
    color:#3f7f95;
    font-weight:500;
}


/* =========================================================
   HORIZONTAL TABS
   ORDER:
   ANALYTICS
   LOW STOCK
   REORDER HISTORY
========================================================= */

.tabs{
    display:flex;

    padding:4px;

    background:#eaf3f6;

    border:1px solid #c9dce2;

    border-radius:12px;
}


/* =========================================================
   TAB
========================================================= */

.tabs a{
    display:flex;
    align-items:center;
    gap:7px;

    text-decoration:none;

    padding:10px 17px;

    border-radius:9px;

    color:#607780;

    font-size:13px;
    font-weight:650;

    white-space:nowrap;

    transition:.2s ease;
}


/* =========================================================
   TAB HOVER
========================================================= */

.tabs a:hover{
    color:#28586d;

    background:#ffffff;
}


/* =========================================================
   ACTIVE TAB
========================================================= */

.tabs a.active{
    background:
        linear-gradient(
            135deg,
            #28586d,
            #1f4657
        );

    color:#ffffff;

    border:1px solid #1f4657;

    box-shadow:
        0 5px 13px rgba(40,88,109,.22);
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
    color:#28586d;

    font-size:20px;
    font-weight:750;

    white-space:nowrap;
}


.section-title h2 i{
    color:#3f7f95;

    margin-right:7px;
}


.section-line{
    height:2px;

    flex:1;

    background:
        linear-gradient(
            90deg,
            #72b9ca,
            rgba(114,185,202,.35),
            transparent
        );
}


/* =========================================================
   TABLE CONTAINER
========================================================= */

.table-container{
    position:relative;
    z-index:3;

    width:100%;

    border:1px solid #c9dce2;

    border-radius:13px;

    overflow:hidden;

    background:#ffffff;

    box-shadow:
        0 8px 20px rgba(31,70,87,.08);
}


/* =========================================================
   TABLE
========================================================= */

table{
    width:100%;
    border-collapse:collapse;
}


/* =========================================================
   TABLE HEADER
========================================================= */

thead{
    background:
        linear-gradient(
            90deg,
            #28586d,
            #3f7f95
        );

    border-bottom:3px solid #72b9ca;
}


th{
    padding:15px 16px;

    text-align:left;

    color:#ffffff;

    font-size:12px;
    font-weight:750;

    text-transform:uppercase;

    letter-spacing:.6px;

    white-space:nowrap;
}


/* =========================================================
   TABLE CELLS
========================================================= */

td{
    padding:15px 16px;

    color:#405861;

    font-size:14px;
    font-weight:500;

    border-bottom:1px solid #e2edf0;

    white-space:nowrap;
}


/* =========================================================
   TABLE ROWS
========================================================= */

tbody tr{
    background:#ffffff;

    transition:.15s ease;
}


tbody tr:nth-child(even){
    background:#f7fbfc;
}


tbody tr:hover{
    background:#eaf3f6;
}


tbody tr:last-child td{
    border-bottom:none;
}


/* =========================================================
   TABLE TEXT
========================================================= */

td:first-child{
    color:#3f7f95;
    font-weight:750;
}


td:nth-child(2){
    color:#28586d;
    font-weight:700;
}


td:nth-child(3){
    color:#3f7f95;
    font-weight:750;
}


/* =========================================================
   STATUS BADGES
========================================================= */

.badge{
    display:inline-flex;

    align-items:center;
    justify-content:center;

    gap:6px;

    min-width:105px;

    padding:6px 14px;

    border-radius:20px;

    font-size:11px;
    font-weight:750;

    border:1px solid transparent;

    white-space:nowrap;
}


/* REQUESTED */

.requested{
    background:#fff4d6;

    color:#87651d;

    border-color:#e4ca82;
}


/* PROCESSING */

.processing{
    background:#e8eaf7;

    color:#53618b;

    border-color:#c6cce2;
}


/* COMPLETED */

.completed{
    background:#e2f2e9;

    color:#397054;

    border-color:#b9d9c5;
}


/* =========================================================
   EMPTY TABLE
========================================================= */

td[colspan="5"]{
    color:#71858d;

    font-size:14px;

    padding:45px 20px !important;

    text-align:center;
}


td[colspan="5"] i{
    color:#3f7f95 !important;
}


/* =========================================================
   HOME BUTTON AREA
========================================================= */

.bottom-navigation{
    position:relative;
    z-index:3;

    display:flex;

    justify-content:flex-end;

    margin-top:22px;
}


/* =========================================================
   HOME BUTTON - DARK TEAL
========================================================= */

.home-btn{
    display:inline-flex;

    align-items:center;
    justify-content:center;

    gap:8px;

    min-width:125px;

    padding:11px 20px;

    text-decoration:none;

    color:#ffffff;

    background:
        linear-gradient(
            135deg,
            #1f4657,
            #28586d
        );

    border:1px solid #1f4657;

    border-radius:9px;

    font-size:13px;
    font-weight:700;

    box-shadow:
        0 6px 14px rgba(31,70,87,.20);

    transition:.2s ease;
}


.home-btn:hover{
    background:
        linear-gradient(
            135deg,
            #173845,
            #1f4657
        );

    transform:translateY(-1px);

    box-shadow:
        0 8px 18px rgba(31,70,87,.25);
}


.home-btn:active{
    transform:translateY(0);
}


/* =========================================================
   RESPONSIVE
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
        justify-content:center;
    }


    .table-container{
        overflow-x:auto;
    }


    table{
        min-width:750px;
    }
}


@media(max-width:650px){

    .page-wrapper{
        padding:12px;
    }


    .card{
        padding:20px 16px;

        border-radius:15px;
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

        font-size:18px;
    }


    .tabs{
        overflow-x:auto;
    }


    .tabs a{
        min-width:120px;

        padding:10px 12px;

        font-size:11px;
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


    .bottom-navigation{
        justify-content:stretch;
    }


    .home-btn{
        width:100%;
    }

}


/* =========================================================
   FINAL STATIC SAFETY
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


        <!-- =================================================
             HEADER
        ================================================= -->

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


            <!-- =================================================
                 HORIZONTAL NAVIGATION
                 ANALYTICS ? LOW STOCK ? REORDER HISTORY
            ================================================= -->

            <div class="tabs">


                <!-- ANALYTICS -->

                <a href="AnalyticsServlet">

                    <i class="fa-solid fa-chart-line"></i>

                    Analytics

                </a>


                <!-- LOW STOCK -->

                <a href="ReorderServlet">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                    Low Stock

                </a>


                <!-- REORDER HISTORY - ACTIVE -->

                <a href="ReorderHistoryServlet"
                   class="active">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    Reorder History

                </a>


            </div>

        </div>


        <!-- =================================================
             SECTION
        ================================================= -->

        <div class="section-title">

            <h2>

                <i class="fa-solid fa-boxes-stacked"></i>

                Reorder Records

            </h2>

            <div class="section-line"></div>

        </div>


        <!-- =================================================
             TABLE
        ================================================= -->

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


        <!-- =================================================
             BOTTOM HOME BUTTON
        ================================================= -->

        <div class="bottom-navigation">

            <a href="index.jsp"
               class="home-btn">

                <i class="fa-solid fa-house"></i>

                Home

            </a>

        </div>


    </div>

</div>


</body>

</html>
