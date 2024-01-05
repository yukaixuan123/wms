using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.AppService.Dtos.Bs
{
    public class UpdateBs_warehouseDto
    {
        public int warehouse_id { get; set; }
        public string ware_code { get; set; }//仓库编号
        public string ware_code3 { get; set; }//仓库编码
        public string ware_name { get; set; }//仓库名称
        public int ware_cap { get; set; }//仓库容量
        public string ware_state { get; set; }//仓库状态
        public string ware_adr { get; set; }//仓库地址
        public string is_default { get; set; }//是否默认
        public int is_lock { get; set; }//仓库锁定
        public string ware_duty_man { get; set; }//仓库主管
        public int sort_code { get; set; }//排序
        public string create_by { get; set; }//操作人
        public DateTime create_time { get; set; }//操作时间
        public string update_by { get; set; }//更新者
        public DateTime update_time { get; set; }//更新时间
        public string is_del { get; set; }//逻辑删除
    }
}
