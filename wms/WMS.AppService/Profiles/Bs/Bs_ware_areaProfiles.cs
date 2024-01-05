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
    public class Bs_ware_areaProfiles : Profile
    {
        public Bs_ware_areaProfiles()
        {
            CreateMap<AddBs_ware_areaDto, Bs_ware_area>().ReverseMap();
            CreateMap<UpdateBs_ware_areaDto, Bs_ware_area>().ReverseMap();
            CreateMap<DelBs_ware_areaDto, Bs_ware_area>().ReverseMap();
        }
    }
}
