using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;


namespace WMS.Controllers.Cm
{
    [ApiController]
    [Route("api/images")]
    public class ImageController : ControllerBase
    {
        [HttpGet("{imagePath}")]
        public IActionResult GetImage(string imagePath)
        {
            try
            {
                var imagePathOnDisk = Path.Combine(Directory.GetCurrentDirectory(), "Uploads", imagePath);

                if (System.IO.File.Exists(imagePathOnDisk))
                {
                    var imageFileStream = new FileStream(imagePathOnDisk, FileMode.Open, FileAccess.Read);
                    return File(imageFileStream, "image/jpeg"); // 假设图片格式为JPEG
                }
                else
                {
                    return NotFound("Image not found");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
    }
