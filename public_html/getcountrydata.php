<!-- 
    Zachary Zhou: zzhou43
    Jamie Huang: jhuan131
    Alexey Solganik: asolgan1

    Given a country name, return country's basic information from Country relation
-->
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>


<body>
    <!-- Set up scripts for Bootstrap CDN  -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>


    <?php
    include 'open.php';
    $country = $_POST['country'];

    if ($stmt = $conn->prepare("CALL GetCountryData(?)")) {
        $stmt->bind_param("s", $country);

        if ($stmt->execute()) {
            $result = $stmt->get_result();
            if ($result->num_rows == 0) {
                echo "<div class=\"card\">";
                echo "<div class=\"card-body\">";
                echo "<p class=\"card-text\">No country of the name " . $country . " was found</p>";
                echo "<a href=\"zzhou43_jhuan131_asolgan1.html\" class=\"card-link\">Back</a>";
                echo "</div>";
                echo "</div>";
            } else {
                $row = $result->fetch_row();
                echo "<div class=\"card\">";
                echo "<div class=\"card-body\">";
                echo "<h5 class=\"card-title\">".$row[0]."</h5>";
                echo "<p class=\"card-text\">Migrant Stock 2020 (% of total population): ".$row[1]."</p>";
                echo "<p class=\"card-text\">Stimulus (% of 2021 GDP): ".$row[2]."</p>";
                echo "<p class=\"card-text\">A member of OECD?: ".($row[3] == 1 ? "True" : "False")."</p>";
                echo "<p class=\"card-text\">Has public healthcare?: ".($row[4] == 1 ? "True" : "False")."</p>";
                echo "<p class=\"card-text\">Most recent daily vaccinations (people): ".$row[5]."</p>";
                echo "<p class=\"card-text\">Total vaccinations (people): ".$row[6]."</p>";
                echo "<a href=\"zzhou43_jhuan131_asolgan1.html\" class=\"card-link\">Back</a>";
                echo "</div>";
                echo "</div>";
            }
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