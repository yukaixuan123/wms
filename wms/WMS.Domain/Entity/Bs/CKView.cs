using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Bs
{
    public class CKView
    {
        //h.,h.,h.,h.,h.,h.,h.,h.,h.,
        public int warehouse_id { get; set; }
        public string ware_code { get; set; }
        public string ware_name { get; set; }
        public int ware_cap { get; set; }
        public string ware_adr { get; set; }
        public string ware_duty_man { get; set; }
        public string ware_state { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public int sum { get; set; }
        public int is_del {  get; set; }
        public string update_by { get; set; }
        public DateTime update_time { get; set; }
        public string dh { get; set; }
        public string remark { get; set; }
    }
}
