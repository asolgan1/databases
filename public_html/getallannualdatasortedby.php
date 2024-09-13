<!-- 
    Zachary Zhou: zzhou43
    Jamie Huang: jhuan131
    Alexey Solganik: asolgan1

    Given a column to sort by and a direction, return all sorted annual data
-->

<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>


<body>
    <!-- Set up scripts for Bootstrap CDN  -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>


    <?php
    include 'open.php';
    $column = $_POST['column'];
    $dir = $_POST['dir'];

    if ($stmt = $conn->prepare("CALL GetAllAnnualDataSortedBy(?, ?)")) {
        $stmt->bind_param("ss", $column, $dir);

        if ($stmt->execute()) {
            $result = $stmt->get_result();
            echo "<a class=\"btn btn-link\" href=\"zzhou43_jhuan131_asolgan1.html\">Back</a>";
            echo "<table class=\"table\">";
            echo "<thead>";
            echo "<tr>";
            echo "<th scope=\"col\">Name</th>";
            echo "<th scope=\"col\">Year</th>";
            echo "<th scope=\"col\">Unemployment Rate (% of labor force) </th>";
            echo "<th scope=\"col\">Net Gov Lending and Borrowing (% of GDP) </th>";
            echo "<th scope=\"col\">Consumer Price Index</th>";
            echo "<th scope=\"col\">Gross Domestic Product (Billions US Dollars)</th>";
            echo "<th scope=\"col\">Population (Thousands of People)</th>";
            echo "<th scope=\"col\">Population Density (Thousands of people per square km)</th>";
            echo "</tr>";
            echo "</thead>";
            while ($row = $result->fetch_row()) {
                echo "<tr>";
                echo "<td>" . $row[0] . "</td>";
                echo "<td>" . $row[1] . "</td>";
                echo "<td>" . $row[2] . "</td>";
                echo "<td>" . $row[3] . "</td>";
                echo "<td>" . $row[4] . "</td>";
                echo "<td>" . $row[5] . "</td>";
                echo "<td>" . $row[6] . "</td>";
                echo "<td>" . $row[7] . "</td>";
                echo "</tr>";
            }
            echo "</table>";
            echo "<a class=\"btn btn-link\" href=\"zzhou43_jhuan131_asolgan1.html\">Back</a>";
            $result->free_result();
        } else {
            echo "Execute failed";
        }

        $stmt->close();
    } else {
        echo "Prepared statment failed";
    }

    $conn->close();
    ?>
</body>