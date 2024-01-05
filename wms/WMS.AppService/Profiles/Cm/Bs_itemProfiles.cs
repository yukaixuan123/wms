using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity.Cm;

namespace WMS.AppService.Profiles.Cm
{
    public class Bs_itemProfiles:Profile
    {
        public Bs_itemProfiles()
        {
            CreateMap<AddBs_itemDtos, Bs_item>().ReverseMap();
            CreateMap<UpdateBs_itemDtos, Bs_item>().ReverseMap();
            //CreateMap<DeleteBs_itemDtos, Bs_item>().ReverseMap();
        }
    }
}
