using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Bs;
using WMS.Domain.Entity.Bs;

namespace WMS.AppService.Profiles.Bs
{
    public class Bs_warehouseProfiles : Profile
    {
        public Bs_warehouseProfiles()
        {
            CreateMap<AddBs_warehouseDto, Bs_warehouse>().ReverseMap();
            CreateMap<UpdateBs_warehouseDto, Bs_warehouse>().ReverseMap();
            CreateMap<DelBs_warehouseDto, Bs_warehouse>().ReverseMap();
        }
    }
}
