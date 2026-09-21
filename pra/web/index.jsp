<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Hardware Management System</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    <style>

        /* =========================================
           GLOBAL
        ========================================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at 20% 20%,
                    rgba(150, 110, 30, 0.10),
                    transparent 25%
                ),

                radial-gradient(
                    circle at 80% 70%,
                    rgba(150, 110, 30, 0.08),
                    transparent 25%
                ),

                #10090b;

            color: #4d2630;

            min-height: 100vh;
        }


        /* =========================================
           CONTAINER
        ========================================= */

        .container {

            width: 90%;

            max-width: 1200px;

            margin: auto;
        }


        /* =========================================
           ADMIN LOGIN BUTTON
        ========================================= */

        .admin-btn-fixed {

            position: fixed;

            top: 20px;

            right: 25px;

            z-index: 1000;

            padding: 12px 22px;

            border-radius: 30px;

            background: #651b36;

            color: #f7e9c5;

            border:
                1px solid #d1ad55;

            font-size: 14px;

            font-weight: bold;

            text-decoration: none;

            box-shadow:
                0 5px 20px rgba(
                    0,
                    0,
                    0,
                    0.35
                );

            transition: 0.3s;
        }


        .admin-btn-fixed i {

            color: #e5c36b;

            margin-right: 7px;
        }


        .admin-btn-fixed:hover {

            background: #7c2344;

            color: white;

            transform: translateY(-3px);

            box-shadow:
                0 8px 25px rgba(
                    0,
                    0,
                    0,
                    0.45
                );
        }


        /* =========================================
           HERO SECTION
        ========================================= */

        .hero {

            min-height: 570px;

            padding: 130px 20px 90px;

            display: flex;

            align-items: center;

            justify-content: center;

            text-align: center;

            color: #f8ebcb;

            background:

                radial-gradient(
                    circle at 50% 40%,
                    rgba(164, 113, 29, 0.20),
                    transparent 30%
                ),

                linear-gradient(
                    135deg,
                    #160a0d 0%,
                    #3a101e 50%,
                    #651b36 100%
                );

            border-bottom:
                2px solid #a27a2e;

            box-shadow:
                0 10px 35px rgba(
                    0,
                    0,
                    0,
                    0.5
                );
        }


        .hero-icon {

            font-size: 65px;

            color: #e4bf62;

            margin-bottom: 20px;

            text-shadow:
                0 4px 15px rgba(
                    0,
                    0,
                    0,
                    0.4
                );
        }


        .hero h1 {

            font-size: 48px;

            font-weight: 700;

            margin-bottom: 20px;

            color: #f8e9c7;

            letter-spacing: 0.5px;
        }


        .hero p {

            font-size: 18px;

            line-height: 1.7;

            color: #eadbc0;

            max-width: 680px;

            margin: 0 auto 32px;
        }


        /* =========================================
           HERO BUTTON
        ========================================= */

        .btn-admin {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            padding: 14px 32px;

            border-radius: 30px;

            background: #e1b957;

            color: #4c2630;

            border:
                1px solid #f0d27a;

            font-size: 16px;

            font-weight: bold;

            text-decoration: none;

            transition: 0.3s;

            box-shadow:
                0 5px 20px rgba(
                    0,
                    0,
                    0,
                    0.25
                );
        }


        .btn-admin:hover {

            background: #f0ce70;

            color: #3f2029;

            transform: translateY(-3px);

            box-shadow:
                0 10px 30px rgba(
                    0,
                    0,
                    0,
                    0.35
                );
        }


        /* =========================================
           FEATURES SECTION
        ========================================= */

        .features {

            padding: 70px 0;

            background: #f1eee7;

            border-bottom:
                1px solid #c4a05a;
        }


        .section-title {

            text-align: center;

            color: #651b36;

            font-size: 30px;

            font-weight: 700;

            margin-bottom: 45px;
        }


        .section-title::after {

            content: "";

            display: block;

            width: 65px;

            height: 3px;

            background: #bd963b;

            margin: 12px auto 0;

            border-radius: 5px;
        }


        /* =========================================
           FEATURE GRID
        ========================================= */

        .feature-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 25px;
        }


        .feature-box {

            text-align: center;

            padding: 30px 20px;

            background: #fffdf8;

            border:
                1px solid #c8a65b;

            border-radius: 15px;

            box-shadow:
                0 5px 18px rgba(
                    71,
                    39,
                    23,
                    0.12
                );

            transition: 0.3s;
        }


        .feature-box:hover {

            transform: translateY(-8px);

            border-color: #9d7428;

            box-shadow:
                0 12px 30px rgba(
                    71,
                    39,
                    23,
                    0.20
                );
        }


        .feature-box i {

            font-size: 43px;

            color: #8a2345;

            margin-bottom: 18px;
        }


        .feature-box h4 {

            color: #651b36;

            font-size: 17px;

            margin-bottom: 12px;

            font-weight: bold;
        }


        .feature-box p {

            color: #806d62;

            font-size: 14px;

            line-height: 1.6;
        }


        /* =========================================
           PRODUCTS SECTION
        ========================================= */

        .product-showcase {

            padding: 70px 0;

            background: #180b0e;
        }


        .product-showcase .section-title {

            color: #f0dfbd;
        }


        .product-grid {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 25px;
        }


        /* =========================================
           PRODUCT CARD
        ========================================= */

        .product-card {

            background: #fffdf8;

            border:
                1px solid #c6a455;

            border-radius: 15px;

            overflow: hidden;

            box-shadow:
                0 8px 25px rgba(
                    0,
                    0,
                    0,
                    0.30
                );

            transition: 0.3s;
        }


        .product-card:hover {

            transform: translateY(-7px);

            box-shadow:
                0 15px 35px rgba(
                    0,
                    0,
                    0,
                    0.45
                );
        }


        /* =========================================
           PRODUCT ICON
        ========================================= */

        .product-image {

            height: 190px;

            display: flex;

            align-items: center;

            justify-content: center;

            color: #f8e8c3;

            font-size: 55px;

            border-bottom:
                3px solid #c6a455;
        }


        .product-image.desktop {

            background:
                linear-gradient(
                    135deg,
                    #4a1429,
                    #7b1e3d
                );
        }


        .product-image.laptop {

            background:
                linear-gradient(
                    135deg,
                    #3c1423,
                    #8b3150
                );
        }


        .product-image.printer {

            background:
                linear-gradient(
                    135deg,
                    #5a281d,
                    #8b5530
                );
        }


        .product-image.monitor {

            background:
                linear-gradient(
                    135deg,
                    #3b2634,
                    #72505d
                );
        }


        /* =========================================
           PRODUCT BODY
        ========================================= */

        .product-body {

            padding: 22px;
        }


        .product-title {

            color: #651b36;

            font-size: 18px;

            font-weight: bold;

            margin-bottom: 8px;
        }


        .product-description {

            color: #806d62;

            font-size: 14px;

            margin-bottom: 15px;
        }


        .price {

            color: #8a2345;

            font-size: 20px;

            font-weight: bold;
        }


        /* =========================================
           FOOTER
        ========================================= */

        footer {

            background:
                linear-gradient(
                    135deg,
                    #10090b,
                    #260d16
                );

            color: #d9c8a7;

            text-align: center;

            padding: 28px;

            border-top:
                1px solid #806127;
        }


        footer p {

            margin: 0;

            font-size: 14px;
        }


        /* =========================================
           RESPONSIVE
        ========================================= */

        @media (max-width: 1000px) {

            .feature-grid,
            .product-grid {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .hero h1 {

                font-size: 40px;
            }

        }


        @media (max-width: 650px) {

            .admin-btn-fixed {

                top: 12px;

                right: 12px;

                padding: 9px 15px;

                font-size: 12px;
            }


            .hero {

                padding:
                    120px 20px
                    70px;
            }


            .hero h1 {

                font-size: 32px;
            }


            .hero p {

                font-size: 15px;
            }


            .feature-grid,
            .product-grid {

                grid-template-columns: 1fr;
            }


            .features,
            .product-showcase {

                padding: 50px 0;
            }


            .section-title {

                font-size: 25px;
            }


            .container {

                width: 92%;
            }

        }

    </style>

</head>


<body>


    <!-- =====================================
         FIXED ADMIN BUTTON
    ====================================== -->

    <a href="${pageContext.request.contextPath}/admin/login.jsp"
       class="admin-btn-fixed">

        <i class="fas fa-user-shield"></i>

        Admin Login

    </a>



    <!-- =====================================
         HERO SECTION
    ====================================== -->

    <section class="hero">

        <div class="container">


            <div class="hero-icon">

                <i class="fas fa-microchip"></i>

            </div>


            <h1>

                Hardware Management System

            </h1>


            <p>

                Efficiently manage your hardware inventory,
                track assets, and streamline operations
                in one place.

            </p>


            <a
                href="${pageContext.request.contextPath}/admin/login.jsp"
                class="btn-admin">

                <i class="fas fa-lock"></i>

                Admin Login

            </a>


        </div>

    </section>



    <!-- =====================================
         FEATURES
    ====================================== -->

    <section class="features">

        <div class="container">


            <h2 class="section-title">

                Why Choose Our System?

            </h2>


            <div class="feature-grid">


                <!-- FEATURE 1 -->

                <div class="feature-box">

                    <i class="fas fa-boxes"></i>

                    <h4>

                        Inventory Management

                    </h4>

                    <p>

                        Track stock levels,
                        locations, and reorder points.

                    </p>

                </div>


                <!-- FEATURE 2 -->

                <div class="feature-box">

                    <i class="fas fa-truck"></i>

                    <h4>

                        Supplier Management

                    </h4>

                    <p>

                        Manage suppliers,
                        feedback, and purchase orders.

                    </p>

                </div>


                <!-- FEATURE 3 -->

                <div class="feature-box">

                    <i class="fas fa-chart-line"></i>

                    <h4>

                        Sales Tracking

                    </h4>

                    <p>

                        Monitor sales,
                        generate reports, and track performance.

                    </p>

                </div>


                <!-- FEATURE 4 -->

                <div class="feature-box">

                    <i class="fas fa-shield-alt"></i>

                    <h4>

                        Secure Admin Panel

                    </h4>

                    <p>

                        Role-based access control
                        for secure management.

                    </p>

                </div>


            </div>

        </div>

    </section>



    <!-- =====================================
         PRODUCTS
    ====================================== -->

    <section class="product-showcase">

        <div class="container">


            <h2 class="section-title">

                Our Products

            </h2>


            <div class="product-grid">


                <!-- PRODUCT 1 -->

                <div class="product-card">


                    <div class="product-image desktop">

                        <i class="fas fa-desktop"></i>

                    </div>


                    <div class="product-body">

                        <h5 class="product-title">

                            Desktop Computer

                        </h5>


                        <p class="product-description">

                            Dell OptiPlex 7090

                        </p>


                        <p class="price">

                            ?50,000

                        </p>

                    </div>


                </div>



                <!-- PRODUCT 2 -->

                <div class="product-card">


                    <div class="product-image laptop">

                        <i class="fas fa-laptop"></i>

                    </div>


                    <div class="product-body">

                        <h5 class="product-title">

                            Laptop Computer

                        </h5>


                        <p class="product-description">

                            HP ProBook 450 G10

                        </p>


                        <p class="price">

                            ?72,000

                        </p>

                    </div>


                </div>



                <!-- PRODUCT 3 -->

                <div class="product-card">


                    <div class="product-image printer">

                        <i class="fas fa-print"></i>

                    </div>


                    <div class="product-body">

                        <h5 class="product-title">

                            Laser Printer

                        </h5>


                        <p class="product-description">

                            Canon LBP2900

                        </p>


                        <p class="price">

                            ?10,000

                        </p>

                    </div>


                </div>



                <!-- PRODUCT 4 -->

                <div class="product-card">


                    <div class="product-image monitor">

                        <i class="fas fa-tv"></i>

                    </div>


                    <div class="product-body">

                        <h5 class="product-title">

                            LED Monitor

                        </h5>


                        <p class="product-description">

                            Samsung LS24R350

                        </p>


                        <p class="price">

                            ?14,500

                        </p>

                    </div>


                </div>


            </div>

        </div>

    </section>



    <!-- =====================================
         FOOTER
    ====================================== -->

    <footer>

        <p>

            © 2024 Hardware Management System.
            All rights reserved.

        </p>

    </footer>


</body>

</html>