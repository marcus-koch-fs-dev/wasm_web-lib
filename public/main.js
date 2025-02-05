async function init() {
  let rustApp = null;
  try {
    rustApp = await import("../pkg/index.js");
  } catch (error) {
    console.error(error);
  }

  console.log(rustApp);

  const input = document.getElementById("upload");
  const fileReader = new FileReader();

  fileReader.onloadend = function () {
    let base64 = fileReader.result.replace(
      /^data:image\/(png|jpg|jpeg);base64,/,
      ""
    );
    let img_data_url = rustApp.grayscale(base64);
    document.getElementById("new-img").setAttribute("src", img_data_url);
  };

  input.addEventListener("change", function () {
    fileReader.readAsDataURL(input.files[0]);
  });
}
init();
