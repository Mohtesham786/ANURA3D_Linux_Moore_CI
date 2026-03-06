# Linking the object files together

## Command line direction

ifort Anura3D.o String.o RotBoundCond.o GlobalConstants.o A3DLinearElasticity.o AdjustParticleDiscretisation.o Anura3D.o BuildBJacDet.o BuildDElastic.o BuildLoad.o Counters.o ElemCalc.o ElemCalcQUAD.o ElemCalcTETRA.o ElemCalcTRI.o ElemConnections.o ErrorHandler.o ExternalSoilModel.o Feedback.o FileIO.o GeoMath.o GetPrinStress.o GetStrain.o getversion.o InitialiseElementType.o InitialiseKernel.o ISORT.o Kernel.o LagrangianPhase.o Liquid.o MatrixMath.o MeshInfo.o mkl_dss.o MPMConvPhase.o MPMData.o MPMDYN2PhaseSP.o MPMDYN3PhaseSP.o MPMDynamicExplicit.o MPMDYNBTSig.o MPMDynContact.o MPMDYNConvPhase.o MPMDYNStresses.o MPMDynViscousBoundary.o MPMEmptyElements.o MPMExcavation.o MPMInit.o MPMMeshAdjustment.o MPMStrainSmoothing.o MPMStresses.o Particle.o ReadCalculationData.o ReadGeometryData.o
ReadMaterialData.o ReadMPMData.o RigidBody.o  Solver.o timing.o TwoLayerFormulation.o WriteMPMData.o WriteNodalData.o
WriteResultData.o WriteTestData.o WriteVTK2Layer.o WriteVTKASCII.o WriteVTKBinary.o WriteVTKOutput.o

## Command Line v2
ifort String.o ErrorHandler.o WriteResultData.o WriteVTKBinary.o WriteVTKOutput.o WriteVTK2Layer.o WriteNodalData.o GlobalConstants.o GeoMath.o MatrixMath.o FileIO.o Counters.o Feedback.o ReadCalculationData.o ElemCalcTETRA.o ElemCalcQUAD.o ElemCalcTRI.o ReadMaterialData.o InitialiseKernel.o ElemCalc.o MeshInfo.o ReadGeometryData.o ISORT.o ElemConnections.o Particle.o MPMData.o RotBoundCond.o MPMStresses.o MPMDynViscousBoundary.o TwoLayerFormulation.o MPMDYN2PhaseSP.o MPMDYN3PhaseSP.o MPMDynContact.o ReadMPMData.o WriteMPMData.o MPMMeshAdjustment.o MPMConvPhase.o WriteTestData.o MPMEmptyElements.o AdjustParticleDiscretisation.o MPMInit.o MPMDYNBTSig.o RigidBody.o LagrangianPhase.o Liquid.o ExternalSoilModel.o MPMStrainSmoothing.o MPMDYNStresses.o MPMDYNConvPhase.o MPMExcavation.o BuildBJacDet.o BuildDElastic.o BuildLoad.o GetPrinStress.o GetStrain.o A3DLinearElasticity.o getversion.o InitialiseElementType.o timing.o WriteVTKASCII.o MPMDynamicExplicit.o Kernel.o Anura3D.o

                                          
        
# Windows work
## command line v1
ifort GlobalConstants.obj A3DLinearElasticity.obj MCSS_Soil_Model.obj GeoMath.obj MatrixMath.obj FileIO.obj String.obj Counters.obj Feedback.obj ReadCalculationData.obj ElemCalcTETRA.obj ElemCalcQUAD.obj ReadMaterialData.obj ElemCalcTRI.obj getversion.obj InitialiseKernel.obj ElemCalc.obj MeshInfo.obj ReadGeometryData.obj ISORT.obj ElemConnections.obj Particle.obj MPMData.obj RotBoundCond.obj MPMStresses.obj MPMDynViscousBoundary.obj TwoLayerFormulation.obj MPMDYN2PhaseSP.obj MPMDYN3PhaseSP.obj MPMDynContact.obj ReadMPMData.obj WriteMPMData.obj MPMMeshAdjustment.obj MPMConvPhase.obj WriteTestData.obj MPMEmptyElements.obj AdjustParticleDiscretisation.obj MPMInit.obj MPMDYNBTSig.obj RigidBody.obj LagrangianPhase.obj Liquid.obj ExternalSoilModel.obj MPMStrainSmoothing.obj MPMDYNStresses.obj MPMDYNConvPhase.obj MPMExcavation.obj BuildBJacDet.obj BuildDElastic.obj BuildLoad.obj GetPrinStress.obj GetStrain.obj InitialiseElementType.obj timing.obj WriteVTKASCII.obj WriteVTKBinary.obj WriteVTKOutput.obj WriteVTK2Layer.obj WriteNodalData.obj WriteResultData.obj ErrorHandler.obj MPMDynamicExplicit.obj Kernel.obj Anura3D.obj


Path to path containing ifort (not neceessary to include)
C:\Program Files (x86)\Intel\oneAPI\compiler\2021.1.1\windows\bin

Path to ifort 
C:\Program Files (x86)\Intel\oneAPI\compiler\2021.1.1\windows\bin\intel64